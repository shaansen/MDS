d3.csv("data2016.csv", function(data) {
    var dataQ = {}
    var newData = {}
    for (var i = 0; i < data.length; i++) {
        dataQ[i] = data[i].mouse_sample;
        newData[data[i].mouse_sample] = data[i]
    }

    var keySet = Object.keys(data[0])
    keySet = keySet.slice(4,keySet.length)

    var dataMap = new Array(data.length)
    for (var i = 0; i < data.length; i++) {
        dataMap[i] = new Array(data.length)
        for (var j = 0; j < data.length; j++) {
            if(i==j) {
                dataMap[i][j] = 0
            } else {
                let calc = calculateStuff(newData[dataQ[i]],newData[dataQ[j]],keySet)
                dataMap[i][j] = calc
            }
        }
    }
   
    console.log(dataMap)
    
    function calculateStuff(var1,var2,keySet) {
        var x = 0;
        for (var i = 0; i < keySet.length; i++) {
            let y = (var1[keySet[i]]-var2[keySet[i]])
            x = x + y*y
        }
        return Math.sqrt(x);
    }
    

});