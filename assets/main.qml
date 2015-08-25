import bb.cascades 1.2
import bb.system 1.0

Page 
{
    Container 
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout { }
        
        leftPadding: 50
        rightPadding: 50
        
        Container 
        {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            
            ActivityIndicator 
            {
                id: loading
                running: visible
                visible: false
                horizontalAlignment: HorizontalAlignment.Center
                preferredHeight: 200
            }
            
            Label 
            {
                text: "Is this domain up?"
                textStyle.fontSize: FontSize.XXLarge
                textStyle.fontWeight: FontWeight.W100
            }

            TextField 
            {
                id: txtURL
                text: "google.ca"
                hintText: "ex: google.com"
            }
            
            Button 
            {
                id: btnCheck
                text: "Check"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onClicked: 
                {
                    loading.visible = true;
                    isItUp(txtURL.text);  
                }
            }
        }
        
        attachedObjects: SystemToast
        {
            id: toast
            
            function pop(text)
            {
                body = text;
                show();
            }
        }
    }
    
    function isItUp(domain) 
    {
        var request = new XMLHttpRequest();
        
        request.onreadystatechange = function() 
        {
            if(request.readyState === XMLHttpRequest.DONE) 
            {
                console.log("Response = " + JSON.stringify(request));
                
                if (request.status === 200) 
                {
                    var responseJSON = JSON.parse(request.responseText);
                    
                    toast.pop("Domain: " + responseJSON.domain + ", Port: " + responseJSON.port + ", Status: " + responseJSON.status_code);
                }
                else 
                {
                    console.log("Status: " + request.status + ", Status Text: " + request.statusText);
                }
                
                loading.visible = false;
            }
        }
        
        var fullURL = "http://isitup.org/" + domain + ".json";
        request.open("GET", fullURL, true);
        request.send();
        
        console.log("Checking: " + fullURL);
    }
}
