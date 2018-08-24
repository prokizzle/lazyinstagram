# LazyInstagram

This project was intended to be the best Instagram bot on the market. It boasts some unique features such as AI image recognition, and zero-configuration photo/user scraping rules.

However, Facebook and Instagram seem to be aggressively fighting off automation bots, and the sustainability of this project doesn't seem feasible.

It currently relies on the Instagram API, and it currently violates the Instagram API, so it will never get approved for production use. The next big milestone will be to rewrite the instagram functionality so it works with a headless browser, such as PhantomJS, instead of the API.

## For Potential Employers

I'm using this as a recent example of my coding style. Feel free to browse through the code to get a feel for how I organize my thoughts and strategies.

### Continuous Deployment Strategies

This project uses CodeShip for Continuous Deployment and deploys to AWS OpsWorks.
Cookbooks can be found here: https://github.com/prokizzle/cookbooks
CodeShip simply executes `bundle exec rake deploy` which can be viewed at `lib/tasks/deploy.rake`.


### React examples

`app/javascript/packs`

### API Wrapper Examples

```
app/models/image_analysis/drivers
app/models/instagram
````

### Background Job Examples

`app/workers`
