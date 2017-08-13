import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from 'lodash'


class NewTermForm extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			search_term: '',
			radius: 6400,
			showForm: false
		}
	}

	handleChange(e) {
		var value = e.target.value;
		var fieldName = e.target.dataset.fieldName;
		var state = _.clone(this.state);
		state[fieldName] = value;
		this.setState(state, () => console.log(this.state));
	}

	handleSubmit(e) {
		e.preventDefault();
		$.post('/discovery-settings', {
			search_term: this.state.search_term,
			radius: +this.state.radius
		})
		this.setState({
			search_term: '',
			radius: '',
			showForm: false
		}, () => {
			this.props.handleUpdate();
		})
	}

	showForm(e) {
		e.preventDefault();
		this.setState({showForm: true})
	}

	render() {
		if (this.state.showForm) {
			return <div>
				<form className='form' onSubmit={this.handleSubmit.bind(this)}>

				<div className='form-group'>
					<label htmlFor='search_term'>Search Term</label>
					<input type='text' value={this.state.search_term} onChange={this.handleChange.bind(this)} className='form-control' id='search_term' data-field-name="search_term"/>
					</div>

					<div className='form-group'>
					<label htmlFor='search_radius'>Radius</label>
					<input type='number' value={this.state.radius} onChange={this.handleChange.bind(this)} className='form-control' id='search_radius' data-field-name="radius"/>
					</div>

					<button type='submit' onClick={this.handleSubmit.bind(this)} className='btn btn-primary btn-sm'>Save</button>
					<button className='btn btn-danger btn-sm' onClick={(e) => this.setState({showForm: false})}>Cancel</button>
				</form>
			</div>;
		} else {
			return <button className='btn btn-primary btn-sm' onClick={this.showForm.bind(this)}>Add New Search Term</button>
		}
	}
}

export default NewTermForm;