import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'


class Whitelist extends React.Component {
    constructor (props) {
        super(props)
        this.state = {
            followedUsers: [],
            whitelistedUsers: []
        }
    }

    componentDidMount () {
        this.fetchFollowedUsers()
    }

    fetchFollowedUsers () {
        $.get('/follows', (users) => {
            this.setState({followedUsers: _.reverse(users)})
        })
    }

    fetchWhitelistedUsers () {
        $.get('/whitelists', (users) => {
            this.setState({whitelistedUsers: users})
        })
    }

    whitelistableUsers() {
        return _.filter(this.state.followedUsers, (user) => {
            return !this.state.whitelistedUsers.includes(user.id)
        })
    }

    userList () {

        return _.map(this.state.followedUsers, (user) => {
            return <div className='card'>
                <div className='row'>
                    <span className='col-4'><img src={user.profile_picture}/></span>
                    <span className='col-4'>{user.username}</span>
                    <span className='col-4'><button onClick={handleAddToWhitelist} data-user-id={user.id}>Whitelist</button></span>
                </div>
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
