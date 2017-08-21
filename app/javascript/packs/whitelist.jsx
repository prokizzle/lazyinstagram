import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'


class Whitelist extends React.Component {
    constructor (props) {
        super(props)
        this.state = {
            followedUsers: [],
            whitelistedUsers: [],
            followers: []
        }
    }

    componentDidMount () {
        this.fetchFollowedUsers()
        this.fetchWhitelistedUsers()
        this.fetchFollowers()
    }

    fetchFollowers() {
        $.get('/followers?ids=true', (users) => {
            this.setState({followers: users})
        })
    }

    fetchFollowedUsers () {
        $.get('/follows', (users) => {
            this.setState({followedUsers: _.reverse(users)})
        })
    }

    fetchWhitelistedUsers () {
        $.get('/whitelists.json', (users) => {
            this.setState({whitelistedUsers: users})
        })
    }

    handleAddToWhitelist (e) {
        e.preventDefault()
        $.post('/whitelists', {instagram_user_id: e.target.dataset.userId}, (users) => {
            this.setState({whitelistedUsers: users})
            
        })
    }

    followsMeStatus (user_id) {
        var status = this.state.followers.includes(user_id)
        return <span>
            { status ? 'Follows you' : "Doesn't follow you" }
        </span>
    }

    whitelistableUsers() {
        var user_ids = _.map(this.state.whitelistedUsers, (user) => { return user.instagram_user_id })
        return _.filter(this.state.followedUsers, (user) => {
            return !user_ids.includes(user.id.toString())
        })
    }

    userList () {

        return _.map(this.whitelistableUsers(), (user) => {
            return <div className='card'>
                <div className='row'>
                    <span className='col-4'><img src={user.profile_picture}/></span>
                    <span className='col-4'>{user.username}</span>
                    {this.followsMeStatus.bind(this)(user.id)}
                    <span className='col-4'>
                        <button className='btn btn-default' onClick={this.handleAddToWhitelist.bind(this)} data-user-id={user.id}>
                            Whitelist
                        </button>
                    </span>
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
