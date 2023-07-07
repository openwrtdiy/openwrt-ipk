# luci-app-mqos
## A Qos luci app filter device by MAC address
使用tc命令进行过滤，未使用mark</br>
由于使用MAC地址匹配，因此理论上可以同时支持 ```IPv4 & IPv6```</br>
支持更改限流接口，目前只支持单接口