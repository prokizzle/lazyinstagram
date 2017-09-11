import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'
import SearchTermsTable from './discovery/search_terms_table'


class Dashboard extends React.Component {
	constructor (props) {
		super(props);
		this.state = {
      queues: {
      }
		}
	}

  queueCards () {
    var queues = _.map(this.state.queues, (value, key) => {
      return {
        queue_name: key,
        value: value
      }
    });
    return _.chunk(queues, 3)
  }

  filters () {
    return {most_popular_tags: function(tags) { 
          if (_.isUndefined(tags)) { 
            return '';
          } else {
            return _.map(tags, (tag) => {
                return <span className='mx-2'>{tag}</span>
            });
          }
        }, 
        images: function (urls) {
          return _.map(urls, (url, key) => {
            return <img height='50' width='50' src={url} key={key}/>
          })
        }
      }
  }

  fetchQueues () {
    $.get('/queues', (data) => {
        this.setState(data);
      });
  }

  componentDidMount () {
    this.fetchQueues()
    setInterval(() => {
      this.fetchQueues()
    }, 3000)
  }

  card (card, i) {
    var formatter = this.filters()[card.queue_name]
    if (_.isUndefined(formatter)) { 
      formatter = function (i) { return i } 
    }
    if (_.isUndefined(this.state.queues[card.queue_name])) { return <div/> } else {

    return <div className='card' key={i}>
        <div className='card-block'>
          <h4 className='card-title'>
            {_.startCase(card.queue_name)}
          </h4>
          <p className='card-text'>
            {
              formatter(this.state.queues[card.queue_name])}
          </p>
        </div>
      </div>
    }
  }

  deck (cards, i) {
      return <div className='row mt-3' key={i}>
        <div className='container'>
          <div className='card-deck'>
            {
              _.map(cards, (card, j) => {return this.card(card, j)})
            }
          </div>
        </div>
      </div>
  }

  cards () {
      if (!_.isEmpty(this.queueCards())) {
          return this.queueCards().map((deck, i) => {
              return this.deck(deck, i)
          })
      } else {
          return <span>Loading...</span>
      }
  }

  randomImages() {
      return <div className='row'>
          {
              _.map(this.state.queues.urls, (url, key) => {
                  return <img src={url} height='150' width='150' className='mx-2' key={key} />
              })
          }
      </div>
  }

  render () {
      return <div className='container'>
          <div className='row'>
              <h1>{_.startCase('lazy_instagram')}</h1>
          </div>
          <div className='row'>
              <div className='col-12'>
              </div>
          </div>
          <div className='row'>
              <div className='col-12'>
                  {this.cards.bind(this)()}
              </div>
          </div>
      </div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <Dashboard />,
        document.querySelector('#dashboard').appendChild(document.createElement('div')),
    )
})
