import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'
import NewTermForm from './new_term_form'


class SearchTermsTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      search_terms: []
    }
  }

  componentDidMount() {
    console.log('mounted')
    this.refreshData();
  }

  refreshData() {
      $.get('/discovery-settings.json', (terms) =>
        this.setState({search_terms: terms})
      )
  }

  rows() {
    var terms = _.reverse(this.state.search_terms);
    return _.map(terms, (query, i) => {
    return <tr key={i}>
      <td>{query.search_term}</td>
      <td>{query.radius}</td>
    </tr>
  });
  }



  table() {
    return <table className='table'>
            <thead>
              <tr>
                <th>Query</th>
                <th>Radius</th>
              </tr>
            </thead>
            <tbody>
              {this.rows.bind(this)()}
            </tbody>
          </table>
  }

  renderContent() {
  if (_.isEmpty(this.state.search_terms)) {
      return <div>
        <p>Loading...</p>
      <i className='fa fa-spinner fa-spin' />
    </div>;
    } else {
      return this.table.bind(this)();
    }
  }

  render() {
    return <div className='container'>
          <NewTermForm handleUpdate={this.refreshData.bind(this)} />
          {this.renderContent.bind(this)()}
        </div>;
  }
}

export default SearchTermsTable