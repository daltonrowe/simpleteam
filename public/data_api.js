class SimpleteamDataApi {
  host = null
  api_key = null
  team_id = nill

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
    return fetch(this.listUrl(), {
      method: 'GET',
      headers: this.headers(),
      params
    })
  }

  listUrl() {
    return new URL(`/teams/${team_id}/data`, this.host)
  }
}