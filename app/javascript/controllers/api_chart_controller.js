import { Controller } from "@hotwired/stimulus";

function lineColor(step, max) {
  const angle = (step / max) * 360;
  return `oklch(75.5% 0.269 ${angle}deg)`;
}

// Connects to data-controller="api-chart"
export default class extends Controller {
  apiResult = null;

  static values = {
    name: String,
    teamId: String,
    apiKey: String,
    keys: String,
    host: String,
  };

  static targets = ["canvas"];

  connect() {
    this.startChart();
  }

  async startChart() {
    await this.waitForLib("SimpleteamDataApi");
    await this.waitForLib("Chart");

    this.apiResult = await this.queryData();

    this.drawChart();
  }

  drawChart() {
    new window.Chart(this.canvasTarget, {
      type: "line",
      data: this.chartData,
      options: {
        color: "white",
        plugins: {
          legend: {
            display: true,
          },
        },
        scales: {
          x: {
            ticks: {
              color: "#DDD",
            },
            grid: {
              display: true,
            },
            title: {
              display: true,
              text: "Date",
              color: "white",
              font: {
                size: 12,
              },
            },
          },
          y: {
            ticks: {
              color: "#DDD",
            },
            title: {
              display: false,
            },
          },
        },
      },
    });
  }

  async waitForLib(global) {
    return new Promise((resolve) => {
      const interval = setInterval(() => {
        if (window[global]) {
          clearInterval(interval);
          resolve();
        } else {
          // do nothing
        }
      }, 100);
    });
  }

  async queryData() {
    const api = new window.SimpleteamDataApi({
      team_id: this.teamIdValue,
      api_key: this.apiKeyValue,
      host: this.hostValue,
    });

    const req = await api.list({ name: this.nameValue });
    const json = await req.json();

    return json;
  }

  get chartData() {
    const sets = [];

    this.keys.forEach((key, i) => {
      sets.push({
        label: key,
        data: this.apiResult.map((row) => row.content[key]),
        backgroundColor: lineColor(i + 1, this.keys.length),
        borderColor: lineColor(i + 1, this.keys.length),
      });
    });

    return {
      labels: this.apiResult.map((row) => {
        const d = new Date(row.created_at);
        return `${d.getUTCMonth() + 1}/${d.getUTCDate()}/${d.getUTCFullYear()}`;
      }),
      datasets: sets,
    };
  }

  get keys() {
    return this.keysValue.split(",");
  }
}
