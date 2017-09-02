import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'
import Toggle from './whitelist/toggle'


class Whitelist extends React.Component {
    constructor (props) {
        super(props)
        this.state = {
            followedUsers: [],
            whitelistedUsers: [],
            filters: {},
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
            this.setState({followedUsers: users})
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

    handleChangeFilter (e) {
        var filters = _.clone(this.state.filters)
        filters[e.target.dataset.filter] = !filters[e.target.dataset.filter] 
        this.setState({filters: filters})
    }

    followsMeStatus (user_id) {
        var status = this.state.followers.includes(user_id)
        return <span>
            { status ? 'Follows you' : "Doesn't follow you" }
        </span>
    }

    whitelistedUser(user_id) {
        var user_ids = _.map(this.state.whitelistedUsers, (user) => { return user.instagram_user_id })
        return user_ids.includes(user_id.toString())
    }


    whitelistableUsers() {
        var users = _.clone(this.state.followedUsers)

        if (this.state.filters.hideWhitelistedUsers) {
            users = _.filter(users, (user) => {
                return !this.whitelistedUser(user.id)
            })
        }
        if (this.state.filters.reverse) {
            users = _.reverse(users)
        }

        if (this.state.filters.followsYou) {
            users = _.filter(users, (user) => {
                return this.state.followers.includes(user.id)
            })
        }
        return users
    }

    controlToggles () {
        return <div>
            <Toggle name='followsYou' 
                value={this.state.filters.followsYou} 
                handleChange={this.handleChangeFilter.bind(this)} />
            <Toggle name='reverse'
                value={this.state.filters.reverse}
                handleChange={this.handleChangeFilter.bind(this)} />
            <Toggle name='hideWhitelistedUsers'
                value={this.state.filters.hideWhitelistedUsers}
                handleChange={this.handleChangeFilter.bind(this)} />
        </div>
    }

    whitelistUserButton (user_id) {
        if (this.whitelistedUser(user_id)) {
            return <span/>
        } else {
            return <button 
                className='btn btn-default' 
                onClick={this.handleAddToWhitelist.bind(this)} 
                data-user-id={user_id}>
                Whitelist
            </button>
        }
    }

    userList () {

        return _.map(this.whitelistableUsers(), (user) => {
            return <div className='card'>
                <div className='row'>
                    <span className='col-4'><img src={user.profile_picture}/></span>
                    <span className='col-4'>{user.username}</span>
                    {this.followsMeStatus.bind(this)(user.id)}
                    <span className='col-4'>
                        {this.whitelistUserButton.bind(this)(user.id)}
                    </span>
                </div>
            </div>
        })
    }

    render () {
        return <div>
            <h1>Whitelist users</h1>
            {this.controlToggles.bind(this)()}
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
