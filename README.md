# About GCG Social
**GCG Social** (name TBD) is Multiplayer Social game and meeting space built by Godot Community Games. The purpose of this project is two-fold: On one hand it serves as a space for the community to hang out virtually. On the other hand, it is an opportunity for the community to learn more about Multiplayer Game Development using a Dedicated Server.

# Running the project
- Open the project in Godot 4.x
- Select Debug > Customize Run Instances
- Enable Multiple Instances
- Create 3 Instances
- In the Feature Tags of the last instance type `is_server`
  - This instance will act as the dedicated server when running locally
- Run the project
- Three windows should open
  - Two of the windows will have an input box, a Connect, and a Disconnect button
  - The last one will now (this is the Dedicated Server)
- Press Connect in both of the clients that have a Connect button
- That's it! Move around with WASD.

