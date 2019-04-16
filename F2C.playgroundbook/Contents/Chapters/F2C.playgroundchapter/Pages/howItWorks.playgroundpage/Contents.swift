/*:
 # How it works? 👀
 **F2C** is a software/hardware architecure, needs both to works correctly. The architecture are splitted in several types of layers. Each layer has their own purpose. These are the layers:
 + Fog layer 1: daily devices (smartphones, consoles, microwaves, smartwatches...). This devices, most common called edges, interconnected creates a huge computational network. This layer could have a billions of devices.
 + Fog layer 2: The devices of the layer 1 needs to be connected to a *fog node*. A *fog node* has the task to coordinate the devices connected to their and share data with other *fog nodes*.
 That means when a problem needs to be distributed, it's the responsible to distribute the amount of work throught the edge nodes. As well, is the responsible to share data with other *fog nodes*. This layer could have millions of nodes.
 + Internet: **F2C** is a distributed architecture, the nodes don't needs to be near. A problem could be solved between far nodes. For this reason, we need internet to connect them as fast as network allows.
 + Cloud: Not all the problems could be solved using edges and nodes, so we need a *cloud* as well to store databases, to have synchronized all the information and why not, to solve problems.
 
 These are the layers of the architecure, so, let's see a problem and how **F2C** could solve it.
 
 # F2C in action! 🚀
 
 Once you were introduced in what's **F2C**, I will show you a real scenario, how it works and what **F2C** have under the hood.
 There is a bunch of possible scenarios to crate and imagine, almost and infinity of them but I choosed one that helps people, at the end is the purpose of everything, try to help people as much as we can (or almost me 🤷🏻‍♂️).
 
 Well... let's begin.
 
 San Francisco as a smart city, June 3rd, WWDC, lots of people, cars, motorcycles, bikes, electric scooters ... many types of vehicles which are controlled by a system in the cloud.
 Every time a camera records an image, a traffic light turns green or the traffic system controls the vehicles, it needs to send all the  information to a cloud, which computes and acts accordingly. This implies data transfer time and computing time and sometimes, a person's safety may depend on a second, a second late may be fatal.
 San Francisco has a smart AI system to prevent car accidents. On top of each traffic light has a camera recording cars paths. If the system detects a possible accident, it turns red the traffic lights to avoid the car accident.
 Every frame that camera records is send to the system (**cloud**) and the images are computed there. For every image sent, approximate time is: **image transfer time + computing time + response time**. A lot of time 😅. The cloud needs to be near and the system needs to have a high-speed connection.
 
 Take a look how we can solve this timing problems using **F2C**.
 Having the above scenario and knowing the layers, look the graph on the right side. You can see the edge devices and nodes.
 The traffic camera edge is recording the frames, every frame is sent to *building node*. Once the node receives the frame, distributes the detection of the possible accidents throught the scooter and the traffic light, when this edges finish the work, the data is sent back to the *building node* and if it's necessary, this node acts accordingly.
 If the amount of work is high, the node could send work to the *house node* and use their edges to check it.
 But... and the Cloud? ☹️ Where is in this scenario?
 The system needs to store everything to analyze later and see how the people is driving (for example). So, once the detection work is completed, the building node sends results to the cloud.
 Sounds good right? We didn't waste time sending the data throught internet just to detect accidents, instead of that, we saved time using a common devices, because, it doesn't look like, but we have it.
 
 Hummm, it's nice, but how is under the hood?? What kind of hardware works in every layer?? Well, you can see it. Look the button at the right corner, I called the **radiography button**. This button allows you to see what kind of computer hardware is used in edges and nodes. 
 Check it by yourself. **PRESS IT❗️❗️**
 
 Yay, now, you can see the radiography of the network, what kind of devices interacts in each layer.
 
 One more feature is waiting for you in the [next page](@next).
 */