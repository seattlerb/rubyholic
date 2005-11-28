var groupManager = {

  toggleAddUrl: function() {
    Element.toggle('new_url')
    Element.toggle('add_url')
  },                               
	
  onCreateUrl: function() {
    Element.show('new_url_spinner')
  },

  onDeleteUrl: function(id) {
    Element.show('url_spinner_'+id)
  },

  toggleAddContact: function() {
    Element.toggle('new_contact')
    Element.toggle('add_contact')
  },                               
	
  onCreateContact: function() {
    Element.show('new_contact_spinner')
  },

  onDeleteContact: function(id) {
    Element.show('contact_spinner_'+id)
  },

  toggleAddLocation: function() {
    Element.toggle('new_location')
    Element.toggle('add_location')
  },                               
	
  onCreateLocation: function() {
    Element.show('new_location_spinner')
  },

  onDeleteLocation: function(id) {
    Element.show('location_spinner_'+id)
  },

  toggleAddSubject: function(id) {
    Element.toggle('new_subject_'+id)
    Element.toggle('add_subject_'+id)
  },                               
	
  onCreateSubject: function(id) {
    Element.show('new_subject_spinner_'+id)
  },

  onDeleteSubject: function(id) {
    Element.show('subject_spinner_'+id)
  },

  toggleAddEvent: function() {
    Element.toggle('new_event')
    Element.toggle('add_event')
  },                               
	
  onCreateEvent: function() {
    Element.show('new_event_spinner')
  },

  onDeleteEvent: function(id) {
    Element.show('event_spinner_'+id)
  },

  placeholder: false

}
