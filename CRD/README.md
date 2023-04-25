2. Define the CustomResourceDefinition.

```Kubernetes CustomResourceDefinition (CRD) is extension point that you can use to implement your own application the Kubernetes-native way, and you can trust it.```
   
 2.1 Create the directory ```mkdir Luxor``` ,  ``` cd  Luxor ```
   
 2.2 Create a new Repo in github 
```git clone URL ( new repo created - repo name ProjectLuxor)  cd ProjectLuxor```

3. Define the CRD
```    3.1 Create yaml file
    vim CustomResourceDefinition.yaml
```apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: resouce.example.crd.com
spec:
  group: example.crd.com
  scope: Namespaced
  names:
    kind: start
    listKind: StartList
    plural: starts
    singular: start
  subresources:
    status: {}
  validation:
    openAPIV3Schema:
      required: ["spec"]
      properties:
        spec:
          required: ["type","location"]
          properties:
            type:
              type: "string"
              minimum: 1
            location:
              type: "string"
              minimum: 1
  versions:
    - name: v1alpha1
      served: true
      storage: true```

    
4. Run commands
```kubectl -f create CustomResourceDefinition.yaml```