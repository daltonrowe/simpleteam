import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="api-chart"
export default class extends Controller {
  apiResult = null;

  static values = {
    name: String,
    teamId: String,
    apiKey: String,
    keys: String,
    host: String
  }

  static targets = ['canvas']

  connect() {
    this.startChart();
  }

  async startChart() {
    await this.waitForLib('SimpleteamDataApi');
    await this.waitForLib('Chart');

    this.apiResult = await this.queryData();

    console.debug(this.apiResult);

    this.drawChart();
  }

  drawChart() {
    console.debug(this.canvasTarget);

    new window.Chart(this.canvasTarget, {
      type: 'bar',
      data: {
        datasets: this.datasets,
      },
      options: {
        aspectRatio: 1.77,
        elements: {
          bar: {
            borderSkipped: true,
          },
        },
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: false,
            position: 'nearest',
            xAlign: 'center',
            yAlign: 'top',
          },
        },
        scales: {
          x: {
            grid: {
              display: false,
            },
            title: {
              display: true,
              text: 'xAxisx',
              color: '#0e2332',
              font: {
                weight: 'bold',
                size: 16,
              },
            },
          },
          y: {
            title: {
              display: true,
              color: '#0e2332',
              font: {
                weight: 'bold',
                size: 16,
              },
              text: 'yAxisy',
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
          clearInterval(interval)
          resolve();
        } else {
          // do nothing
        }
      }, 100);
    })
  }

  async queryData() {
    const api = new window.SimpleteamDataApi({
      team_id: this.teamIdValue,
      api_key: this.apiKeyValue,
      host: this.hostValue
    })

    console.debug(this.nameValue);

    const req = await api.list({ name: this.nameValue })
    const json = await req.json();

    return json
  }

  get datasets() {
    console.debug(this.keys);

    const sets = [];

    this.keys.forEach(key => {
      sets.push({
        label: key,
        data: this.apiResult.map(row => row.content[key]),
        backgroundColor: '#4878f1',
        hoverBackgroundColor: '#4878f1',
        barPercentage: 1,
      },)
    })

    console.debug(sets);

    return sets
  }

  get keys() {
    return this.keysValue.split(",")
  }
}
