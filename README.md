# Cloud Computing - TP3

## Hortz
<img src="./resources/images/hortz.png" width="300" height="300" />

## Problema

Una empresa de alquiler de automóviles quiere expandirse a otras regiones nacionales e internacionales. La misma cuenta en la actualidad con un data center on-premise en sus oficinas y solo maneja alquileres locales. Al expandirse, deberá poder soportar una gran cantidad de conexiones simultáneas, provenientes de diversas locaciones y una alta disponibilidad.

Se necesita desarrollar un sistema que permita a los empleados de las sucursales manejar los alquileres y permitir a los gerentes ver métricas y tableros de BI para analizar el negocio y obtener estadísticas. Adicionalmente, los clientes deben poder registrarse para realizar alquileres.

## Solución

Se decide crear una única aplicación web para resolver todos los problemas. Esta aplicación se basa en una arquitectura serverless hosteada en la región en la que se encuentran las actuales oficinas de la empresa (mayor cantidad de clientes actuales), bajo múltiples zonas de disponibilidad para asegurar redundancia y alta disponibilidad.

Los recursos estáticos de la aplicación se encuentran en un bucket S3 Standard que nos da alta disponibilidad. Adicionalmente, utilizamos un CloudFront CDN para asegurar menor latencia si se accede desde distintas partes del mundo. Por otro lado, la capa de aplicación ejecutará funciones Lambda que realizan operaciones sobre una base de datos Aurora Serverless. Para la funcionalidad de BI requerida, utilizamos un Glue DataBrew ETL que transforma la base de datos transaccional Aurora en un formato que nos permita analizar mejor esta información y la vuelca en un Data Lake S3. Finalmente, se utiliza Athena para realizar queries a este bucket y mostrar la información en QuickSight que leerán los managers. Para garantizar la seguridad y las distintas funcionalidades por roles según el tipo de usuario que utilice la aplicación utilizamos Cognito para la autenticación, IAM para los permisos de los roles y WAF para la protección de la red.


## Para correr
Primero hay que correr el comando:
```
$env:TF_VAR_name_prefix = '{nombre identificatorio}'
```
o configurar en las variables a mano en el archivo `config.tfvars` (para esto, copiar el template `config.example.tfvars` y guardarlo con el nombre `config.tfvars`) y reemplazar el comando plan y apply por:
```
terraform plan -var-file="config.tfvars"
terraform apply -var-file="config.tfvars"
```

Para que los buckets que se creen no coincidan con los de otras personas.

Luego ya se pueden correr los comandos dentro de la carpeta *terraform/organization/tp3*
```
terraform init
terraform plan
terraform apply
```

Para probar la lambda chequear que la table users en dynamo no tiene nada, despues entrar a la pagina y apretar el boton naranja que dice `Try out the Lambda!!!!` y verificar que se crea una entrada en la tabla de dynamo.

## Route 53 y ACM

Para configurar el DNS junto con el certificado SSL, deberá descomentar las secciones bajo el tag `[f76f250f]`, ya que cargar modulos condicionalmente no es práctico en terraform, y ensuciaría demasiado el código (usar un `count` por cada recurso del módulo).

Se investigó al respecto, pero siguiendo la respuesta de [este link](https://blog.dataminded.com/how-to-conditionally-disable-modules-in-terraform-f38fdbe34f1b), al igual que otros, no es práctico hacer esto en este momento.

Por eso, para habilitar Route 53 y ACM, si se cuenta con una hosted zone que apunte al domain name del sitio (se configura desde `config.tfvars`), se deberá buscar todas las entradas de la etiqueta `[f76f250f]`, descomentando los bloques de código respectivos. Para hacer esto deberá contar con una Hosted Zone. 

## Rúbrica

| Integrante                | Legajo | Participación
| ------------------------- | ------ | -------------
| Baiges, Matías Sebastián  | 59076  | 25%
| Bilevich, Andrés Leonardo | 59108  | 25%
| Margossian, Gabriel Viken | 59130  | 25%
| Cristobal, Matías Rojas   | 58564  | 25%
