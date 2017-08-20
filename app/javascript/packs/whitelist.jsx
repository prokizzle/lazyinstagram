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

    handleAddToWhitelist (e) {
        e.preventDefault()
        console.log(e.target.dataset.userId)
        $.post('/whitelists', {instagram_user_id: e.target.dataset.userId}, (users) => {
            this.setState({whitelistedUsers: users})
            
        })
    }

    whitelistableUsers() {
        var user_ids = _.map(this.state.whitelistedUsers, (user) => { return user.instagram_user_id })
        return _.filter(this.state.followedUsers, (user) => {
            return !user_ids.includes(user.instagram_user_id)
        })
    }

    userList () {

        return _.map(this.whitelistableUsers(), (user) => {
            return <div className='card'>
                <div className='row'>
                    <span className='col-4'><img src={user.profile_picture}/></span>
                    <span className='col-4'>{user.username}</span>
                    <span className='col-4'><button onClick={this.handleAddToWhitelist.bind(this)} data-user-id={user.id}>Whitelist</button></span>
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
