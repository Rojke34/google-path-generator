# google-path-generator
Project to help me to generate the path to send to Google Maps sdk

The idea was to generate String-path to sent to google maps object, something like that

![WhatsApp Image 2021-03-02 at 11 07 46](https://user-images.githubusercontent.com/5931219/111199960-391dbd80-858f-11eb-9887-bfa6a9167663.jpeg)


Then I use tha string from the serve to paint on map

```
let path = GMSPath(fromEncodedPath: stringPath)
let polyline = GMSPolyline(path: path)
polyline.strokeWidth = 5
polyline.strokeColor = .blue
polyline.map = mapView
```
