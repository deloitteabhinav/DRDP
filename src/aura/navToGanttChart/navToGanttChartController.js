({
    init: function(component, event, helper){
        window.open('/apex/GanttChartDev?id=' +component.get("v.recordId"));
        setTimeout(function () {
            $A.get("e.force:closeQuickAction").fire();
        }, 1000);
    },
})