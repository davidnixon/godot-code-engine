# Recipe for deploying Godot websocket game on IBM Code Engine
- [Initial Deploy](#initial-deploy)
- [Update apps](#update-apps)
- [Developing locally](#developing-locally)

### Initial Deploy

1. Install ibmcloud cli `curl -fsSL https://clis.cloud.ibm.com/install/linux | sh`
   - Install Code Engine plugin `ibmcloud plugin install code-engine`
   - Install Container Registry plugin `ibmcloud plugin install container-registry`
2. Login to IBM cloud
   ```shell
   ibmcloud login --apikey YOUR-APIKEY -g YOUR-GROUP -r us-south
   ibmcloud cr login
   ```
3. [Create a registry namespace for your project](https://cloud.ibm.com/registry/namespaces)
4. [Create a Code Engine project](https://cloud.ibm.com/codeengine/projects)
5. Open `godot-code-engine/server/project.godot` in Godot and export to `ce/server/dist/` it as a Linux app
6. Build a docker image for the websocket server
   ```shell
   cd godot-code-engine/ce/server
   podman build -t ce-websocket-server .
   ```
7. Push the sever image to the IBM container registry
   ```shell
   docker tag ce-websocket-server:latest us.icr.io/YOUR-NAMESPACE/ce-websocket-server:latest
   docker push us.icr.io/YOUR-NAMESPACE/ce-websocket-server:latest
   ```
8. Deploy this image as a new app
   - [Open your Code Engine project](https://cloud.ibm.com/codeengine/projects)
   - Click Create application
   - Use "server" as the name, the image you just pushed, and port 8080. Set the runtime instances to 1.
   - After the server is deployed, click "Domain mappings" and copy the url of the new server. i.e. "server.xyz123.us-east.codeengine.appdomain.cloud"
9. Open `godot-code-engine/game/project.godot` in Godot
   - Edit the connection string to match the newly deployed server `wss://server.xyz123.us-east.codeengine.appdomain.cloud` 
   - Export the project to  `ce/game/dist/` it as an HTML5 app
10. Build a docker image for the game
    ```shell
    cd godot-code-engine/ce/game
    curl https://downloads.tuxfamily.org/godotengine/3.5.1/Godot_v3.5.1-stable_linux_headless.64.zip
    unzip Godot_v3.5.1-stable_linux_headless.64.zip
    podman build -t ce-websocket-game .
    ```
11. Push the game image to the IBM container registry
    ```shell
    docker tag ce-websocket-game:latest us.icr.io/YOUR-NAMESPACE/ce-websocket-game:latest
    docker push us.icr.io/YOUR-NAMESPACE/ce-websocket-game:latest
    ```   
12. Deploy this image as a new app
    - [Open your Code Engine project](https://cloud.ibm.com/codeengine/projects)
    - Click Create application
    - Use "game" as the name, the image you just pushed, and port 8080. Set the runtime instances to 1.
    - After the game is deployed, click "Test application" and "Application URL". The game should launch in your browser and the connect button should connect your instance to the chat.

[Back to top](#recipe-for-deploying-godot-websocket-game-on-ibm-code-engine)

### Update apps
1. Login to IBM cloud
   ```shell
   ibmcloud login --apikey YOUR-APIKEY -g YOUR-GROUP -r us-south
   ibmcloud cr login
   ```
2. Build docker image and push to registry as described above
3. If your code engine app is in a different region than the container registry, target the new region `ibmcloud target -r us-east`
4. Target the project `ibmcloud ce project select --name YOUR-PROJECT`
5. Update to the latest image `ibmcloud ce app update --name game` and/or `ibmcloud ce app update --name server`

[Back to top](#recipe-for-deploying-godot-websocket-game-on-ibm-code-engine)

### Developing locally

- TBD the connection string in the cloud needs to be "wss://" but locally "ws://" is easier. Probably this can be an env var.
- The docker images are not needed locally, but you can test them locally before deploying.
   ```shell
   podman run -it --rm -p 9999:8080 ce-websocket-game
   ```
   Open local browser to http://localhost:9999

[Back to top](#recipe-for-deploying-godot-websocket-game-on-ibm-code-engine)
