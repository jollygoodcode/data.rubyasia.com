# data.rubyasia.com

## Repositories Data

Repositories json data live in region folder under `data/repos`: `data/repos/:region/repos-:period.json`.

For instance `data/repos/singapore/repos-2016-02-24_2016-03-01`:

```json
{
  "generated_at": "2016-03-02 01:42:57 UTC",
  "criteria": "language:Ruby stars:>20 pushed:2016-02-24..2016-03-01",
  "repos": [
    {
      "full_name": "jollygoodcode/dasherize",
      "description": ":computer: Dasherize your projects",
      "html_url": "https://github.com/jollygoodcode/dasherize",
      "stars": 98,
      "language": "Ruby",
      "region": "Singapore"
    },
    {
      "full_name": "jollygoodcode/reread",
      "description": "Source of https://reread.io",
      "html_url": "https://github.com/jollygoodcode/reread",
      "stars": 70,
      "language": "Ruby",
      "region": "Singapore"
    }
  ]
}
```

## Users Data

Rubyists json data live in region folder under `data/users`: `data/users/:region/:id.json`.

For instance `data/users/taiwan/1000669.json`:

```json
{
  "login": "JuanitoFatas",
  "id": 1000669,
  "avatar_url": "https://avatars.githubusercontent.com/u/1000669?v=3",
  "gravatar_id": "",
  "url": "https://api.github.com/users/JuanitoFatas",
  "html_url": "https://github.com/JuanitoFatas",
  "followers_url": "https://api.github.com/users/JuanitoFatas/followers",
  "following_url": "https://api.github.com/users/JuanitoFatas/following{/other_user}",
  "gists_url": "https://api.github.com/users/JuanitoFatas/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/JuanitoFatas/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/JuanitoFatas/subscriptions",
  "organizations_url": "https://api.github.com/users/JuanitoFatas/orgs",
  "repos_url": "https://api.github.com/users/JuanitoFatas/repos",
  "events_url": "https://api.github.com/users/JuanitoFatas/events{/privacy}",
  "received_events_url": "https://api.github.com/users/JuanitoFatas/received_events",
  "type": "User",
  "site_admin": false,
  "score": 1.0
}
```

## Setup

Run `bin/setup` and follow the instructions.

## Show available regions to fetch data

    $ rake regions_list

## Repos Fetch Criteria

### Fetch repositories data from all regions listed in [regions](/regions) file

    $ rake fetch_repos[all]

### Fetch repositories in Specific Region

    $ rake fetch_repos[Singapore]

If you experience any error when passing argument, wrap it in String to avoid:

    $ rake "fetch_repos[Sri Lanka]"

## Users Fetch Criteria

A Rubyist has at least 1 repository, for example Rubyists in Singapore:

[location:Singapore repos:>=1 language:Ruby](https://github.com/search?utf8=%E2%9C%93&q=location%3ASingapore+repos%3A%3E%3D1+language%3ARuby&type=Users&ref=searchresults)

### Fetch developers data from all regions listed in [regions](/regions) file

    $ rake fetch_developers[all]

### Fetch developers in Specific Region

    $ rake fetch_developers[Japan]

If you experience any error when passing argument, wrap it in String to avoid:

    $ rake "fetch_developers[Sri Lanka]"

## The UNLICENSE

See [UNLICENSE](/UNLICENSE).
