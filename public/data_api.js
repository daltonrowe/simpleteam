class SimpleteamDataApi {
  host = null
  api_key = null
  team_id = null

  constructor({ team_id, api_key, host = 'https://simpleteam.dev' }) {
    this.api_key = api_key
    this.team_id = team_id
    this.host = host
  }

  headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': this.api_key
    }
  }

  list(params) {
    return fetch(this.apiUrl(params), {
      method: 'GET',
      headers: this.headers(),
    })
  }

  last(name) {
    return fetch(this.apiUrl({
      name,
      per_page: 1,
      page: 1
    }), {
      method: 'GET',
      headers: this.headers(),
    })
  }

  create(name, content) {
    return fetch(this.apiUrl(), {
      method: 'POST',
      headers: this.headers(),
      body: JSON.stringify({
        name,
        content
      })
    })
  }

  destroy(id) {
    return fetch(`${this.apiUrl()}/${id}`, {
      method: 'DELETE',
      headers: this.headers(),
    })
  }

  apiUrl(params = null) {
    const url = new URL(`/teams/${this.team_id}/data`, this.host)

    if (params) {
      Object.keys(params).forEach(key => {
        url.searchParams.append(key, params[key])
      });
    }

    return url.toString()
  }
}

if (window) window.SimpleteamDataApi = SimpleteamDataApi