---
title: "R Markdown and Leaflet"
author: "Juan Agustín Morello"
date: "17/9/2020"
output: 
  html_document:
    keep_md: yes
---

# Thursday 17/09/20
## Three places in Japan I hope to visit sometime!


```r
library(leaflet)

df <- data.frame(lat=c(35.360638, 34.967222, 35.710029),
                 lng=c(138.729050, 135.772778, 139.810704),
                 name=c("Mt. Fuji", "Fushimi Inari-Taisha", "Tokyo Skytree"))

japanIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/png/512/129/129352.png",
	iconWidth = 31*215/230, iconHeight = 31,
	iconAnchorX = 31*215/230/2, iconAnchorY =16
)

my_map <- df[,1:2] %>% leaflet() %>% addTiles() %>%
          addMarkers(icon = japanIcon,
                     popup = df$name)
my_map
```

<!--html_preserve--><div id="htmlwidget-ae1367b8e98253e21736" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-ae1367b8e98253e21736">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[35.360638,34.967222,35.710029],[138.72905,135.772778,139.810704],{"iconUrl":{"data":"https://image.flaticon.com/icons/png/512/129/129352.png","index":0},"iconWidth":28.9782608695652,"iconHeight":31,"iconAnchorX":14.4891304347826,"iconAnchorY":16},null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},["Mt. Fuji","Fushimi Inari-Taisha","Tokyo Skytree"],null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[34.967222,35.710029],"lng":[135.772778,139.810704]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

