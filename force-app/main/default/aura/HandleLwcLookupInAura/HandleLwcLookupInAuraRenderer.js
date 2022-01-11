({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.helperMethodTo(cmp);
        helper.helperMethodFrom(cmp);
        console.log('render input fields')
    }

})