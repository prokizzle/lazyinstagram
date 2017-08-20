import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'


class Whitelist extends React.Component {
    constructor (props) {
        super(props)
        this.state = {
            followedUsers: []
        }
    }

    componentDidMount () {
        this.fetchFollowedUsers()
    }

    fetchFollowedUsers () {
        $.get('/follows', (users) => {
            this.setState(followedUsers: users)
        })
    }

    userList () {
        return _.map(this.state.followedUsers, (user) => {
            return <div className='card'>
                <span><img src={user.profile_picture}/></span>
                <span>{user.username}</span>
            </div>
        })
    }

    render () {
        return <div>
            <h1>Whitelist users</h1>

            {this.userList.bind(this)()}
        </div>
    }
}


document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Whitelist />,
    document.querySelector('#whitelist').appendChild(document.createElement('div')),
  )
})
