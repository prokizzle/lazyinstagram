import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'


const Toggle = function(props) {
        return <div className='form-check'>
            <input id={props.name} 
                type='checkbox' 
                value={props.value} 
                onChange={props.handleChange} 
                className='form-check-input'
                data-filter={props.name}
            />
            <label htmlFor={props.name} className='form-check-label'>{_.startCase(props.name)}</label>
        </div>
    }

export default Toggle;
