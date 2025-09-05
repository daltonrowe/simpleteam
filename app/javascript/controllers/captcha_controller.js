import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="captcha"
export default class extends Controller {
  interval = null;
  scriptSrc =
    "https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit";
  widgetId = null;

  connect() {
    if (!Boolean(this.enabled)) return;
    if (!window.turnstile) this.poll();
  }

  poll() {
    this.interval = setInterval(() => {
      if (window.turnstile) {
        clearInterval(this.interval);
        this.render();
      }
    }, 200);

    this.insert();
  }

  insert() {
    const script = document.createElement("SCRIPT");
    script.src = this.scriptSrc;
    document.head.appendChild(script);
  }

  render() {
    this.widgetId = turnstile.render(this.element, {
      ...this.captchaArgs,
      execution: "execute",
    });
  }

  submit(event) {
    if (this.token) turnstile.reset(this.widgetId);

    if (event.submitter) {
      event.preventDefault();
      turnstile.execute(this.element, {
        ...this.captchaArgs,
        callback: this.success,
        "error-callback": this.error,
        "expired-callback": this.expired,
      });
    }
  }

  success = (token) => {
    this.token = token;
    this.element.requestSubmit();
  };

  error() {
    alert("Error validating captcha.");
  }

  expired() {
    alert("Captcha expired.");
  }

  get siteKey() {
    return document.body.dataset.captchaSiteKey;
  }

  get enabled() {
    return document.body.dataset.captchaEnabled;
  }

  get token() {
    return this.element.querySelector("input[name=cf_token]");
  }

  set token(value) {
    if (!this.token) {
      const input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("name", "cf_token");
      this.element.appendChild(input);
    }

    this.token.value = value;
  }

  get captchaArgs() {
    return {
      action: this.element.dataset.captchaAction || "generic",
      sitekey: this.siteKey,
      "feedback-enabled": false,
      "response-field": false,
    };
  }
}
