Install Jenkins by running the helm install command and passing it the following arguments:

- The name of the release `jenkins`.
- The `-f` flag with the YAML file with overrides `jenkins-values.yaml`.
- The name of the chart `jenkinsci/jenkins`.
- The `-n` flag with the name of your namespace `jenkins`.

```
cd deploy
helm install jenkins -n jenkins -f jenkins-values.yml jenkinsci/jenkins 
```

This outputs something similar to the following:

```
NAME: jenkins
LAST DEPLOYED: Tue Oct 29 19:46:47 2024
NAMESPACE: jenkins
STATUS: deployed
REVISION: 1
```

Expose Jenkins service:
```
minikube service jenkins -n jenkins 
```

This command will open a web browser with the Jenkins URL.