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
    return _.chunk([
      {
        title: 'Image Rekognition Queue',
        queue_name: 'analysis_queue'
      },
      {
        title: 'Like Queue',
        queue_name: 'like_queue'
      },
      {
        title: 'Total Photos',
        queue_name: 'photos'
      },
      {
        title: 'Total Liked',
        queue_name: 'liked'
      }
    ], 3)
  }

  componentDidMount () {
    setInterval(() => {
      $.get('/queues', (data) => {
        this.setState(data);
      });
    }, 10000)
  }

  card (card, i) {
    return <div className='card' key={i}>
        <div className='card-block'>
          <h4 className='card-title'>
            {card.title}
          </h4>
          <p className='card-text'>
            {this.state.queues[card.queue_name] || 0}
          </p>
        </div>
      </div>
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
    return this.queueCards().map((deck, i) => {
      return this.deck(deck, i)
    })
  }

  render () {
    return <div className='container'>
      <div className='row'>
        <h1>Lazy Instagram</h1>
      </div>
      {this.cards.bind(this)()}
	  </div>;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Dashboard />,
    document.querySelector('#dashboard').appendChild(document.createElement('div')),
  )
})