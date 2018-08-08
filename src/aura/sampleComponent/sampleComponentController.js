({
	handleevent: function(component, event, helper) {
		console.log('event fired');
        $A.get('e.force:refreshView').fire();
	}
})