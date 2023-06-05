[![Gem Version](https://badge.fury.io/rb/eyeloupe.svg)](https://badge.fury.io/rb/eyeloupe)

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<br />
<div align="center">
  <a href="https://github.com/alxlion/eyeloupe">
    <img src="app/assets/images/eyeloupe/logo.png" width=120 alt="Logo" >
  </a>

<h3 align="center">Eyeloupe (beta)</h3>

  <p align="center">
    The elegant Rails debug assistant.
    <br />
    <a href="https://github.com/alxlion/eyeloupe/issues">Report Bug</a>
    ·
    <a href="https://github.com/alxlion/eyeloupe/issues">Request Feature</a>
  </p>
</div>

[![Eyeloupe screenshot][eyeloupe-screen]](https://github.com/alxlion/eyeloupe)

Eyeloupe is the elegant Rails debug assistant. It helps you to debug your Rails application by providing a simple and elegant interface to view your incoming and outgoing requests (and a lot more to come).

## Installation
Add this line to your application's Gemfile:

```ruby
gem "eyeloupe"
```

And then execute:
```bash
$ bundle
```

Install Eyeloupe migrations into your project:
```bash
$ rails eyeloupe:install:migrations
```

And run the migrations:
```bash
$ rails db:migrate
```

To access Eyeloupe dashboard you need to add the following route to your `config/routes.rb` file:
```ruby
mount Eyeloupe::Engine => "/eyeloupe"
```

## Configuration

This is an example of the configuration you can add to your `initializers/eyeloupe.rb` file:

```ruby
Eyeloupe.configure do |config|
  config.excluded_paths = %w[assets favicon.ico service-worker.js manifest.json]
  config.capture = Rails.env.development?
end
```

- `excluded_paths` is an array of paths you want to exclude from Eyeloupe capture. Eyeloupe adds these excluded paths to the default ones: ` %w[mini-profiler eyeloupe active_storage]`
- `capture` is a boolean to enable/disable Eyeloupe capture. By default, it's set to `true`.

## Usage

Eyeloupe is exclusively developed for the Rails framework.

You can use it in your development environment to debug your application but it's not recommended to use it in production.

### Auto-refresh

By activating auto-fresh, every _3 seconds_ the page will be refreshed to show you the latest data.

### Delete all data

You can delete all the data stored by Eyeloupe by clicking on the trash button.


## Q/A

### Why the request time is not the same on rack-mini-profiler ?

Eyeloupe is not a performance-oriented tool, the request time is the same you can view in the Rails log. If you want more details about your load time, you can use rack-mini-profiler along with Eyeloupe.

### Is this the Laravel Telescope for Rails ?

Yes, Eyeloupe is inspired by Laravel Telescope. A lot of people coming from Laravel are missing Telescope or looking for something similar, so Eyeloupe is here to fill this gap.

## Roadmap

- [ ] Exceptions - Track all the exceptions thrown by your application
- [ ] Custom links to the menu - To access all of your debug tool in one place (Sidekiq web, Mailhog, etc.)

## Contributing
Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing_feature`)
3. Commit your Changes (`git commit -m 'Add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing_feature`)
5. Open a Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contact

[![](https://img.shields.io/badge/@alxlion__-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/alxlion_)

Project Link: [https://github.com/alxlion/eyeloupe](https://github.com/alxlion/eyeloupe)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/alxlion/eyeloupe.svg?style=for-the-badge
[contributors-url]: https://github.com/alxlion/eyeloupe/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/alxlion/eyeloupe.svg?style=for-the-badge
[forks-url]: https://github.com/alxlion/eyeloupe/network/members
[stars-shield]: https://img.shields.io/github/stars/alxlion/eyeloupe.svg?style=for-the-badge
[stars-url]: https://github.com/alxlion/eyeloupe/stargazers
[issues-shield]: https://img.shields.io/github/issues/alxlion/eyeloupe.svg?style=for-the-badge
[issues-url]: https://github.com/alxlion/eyeloupe/issues
[license-shield]: https://img.shields.io/github/license/alxlion/eyeloupe.svg?style=for-the-badge
[license-url]: https://github.com/alxlion/eyeloupe/blob/master/MIT-LICENSE.txt
[eyeloupe-screen]: /doc/img/screen.png
[gem-version]: https://badge.fury.io/rb/eyeloupe.svg
[gem-url]: https://rubygems.org/gems/eyeloupe
