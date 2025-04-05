
#  **Características**

Herramienta que ayuda a construir archivos con estructura y anotaciones predefinidas desde la línea de comando.

Ideal para acelerar el desarrollo en proyectos Spring Boot.

Soporta nombres personalizados. Ejemplo: "... rc User"  crea el "../controller/UserController.java".

Si la carpeta contenedora (controller, dto, service, etc) no existe, la crea. Si existe, solo crea el nuevo archivo solicitado dentro de ella.

Importante:
no sobrescribe archivos existentes.

Documentación integrada, comando:

  bash ../SpringBootCli/build.sh --info


#  **Tipos soportados**


| Comando | Tipo          | Descripción                                                       |
|---------|---------------|-------------------------------------------------------------------|
| cf      | Configuration | Crea una clase `@Configuration`                                   |
| dt      | DTO           | Crea una clase Data Transfer Object (DTO)                         |
| ex      | Exception     | Crea una clase que extiende de `Exception`                        |
| md      | Modelo        | Crea una clase simple                                             |
| rc      | Controller    | Crea una clase `@RestController`                                  |
| rp      | Repository    | Crea una interfaz `JpaRepository`                                 |
| sv      | Service       | Crea una carpeta nueva con el nombre del parámetro. Dentro, una interfaz y una clase que implementa esa interfaz |
| ut      | Utilidad      | Crea una clase simple                                             |




#  **Modo de uso**
1 - Colocar el proyecto dentro del workspace local. Alineado con el resto de los proyectos.

2 - Ejecutar el comando bash, siempre teniendo en cuenta donde se encuentra el .sh.

3 - Posicionarse dentro del proyecto donde se va a usar. Ejecutar el comando.


##  **Ejemplos de uso:**
1)
  Comando:
  
        bash ../SpringBootCli/build.sh cf Swagger
  
  Resultado:
  
        Crea la clase SwaggerConfig.java en .../config/

3)
  Comando:
  
         bash ../SpringBootCli/build.sh sv Producto
  
  Resultado:
  
         Crea la interface IProductoService y la clase ProductoServiceImpl en .../service/producto
