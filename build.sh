#!/bin/bash

# Funcion para mostrar ayuda
show_info() {
    echo ""
    echo "Contructor de archivos para Spring Boot"
    echo "Uso: $0 <tipo> <nombre>"
    echo "O:   $0 --info"
    echo ""
    echo "==================================================================================="
    echo "|           Tipos de Archivos Soportados                                          | "
    echo "==================================================================================="
    echo "| Comando | Tipo            | Descripcion                                         |"
    echo "-----------------------------------------------------------------------------------"
    echo "| cf      | Configuration   | Crea una clase @Configuration                       |"
    echo "-----------------------------------------------------------------------------------"
    echo "| dt      | DTO             | Crea una clase Data Transfer Object.                |"
    echo "-----------------------------------------------------------------------------------"
    echo "| ex      | Exception       | Crea una clase que extiende de Exception.           |"
    echo "-----------------------------------------------------------------------------------"
    echo "| md      | Modelo          | Crea una clase simple.                              |"
    echo "-----------------------------------------------------------------------------------"
    echo "| rc      | Controller      | Crea una clase @RestController.                     |"
    echo "-----------------------------------------------------------------------------------"
    echo "| rp      | Repository      | Crea una intefarce JpaRepository                    |"
    echo "-----------------------------------------------------------------------------------"
    echo "| sv      | Service         | Crea una carpeta nueva con el nombre del parametro. |"
    echo "|         |                 | Dentro una inteface y una clase que implementa esa  |"
    echo "|         |                 | interface.                                          |"
    echo "-----------------------------------------------------------------------------------"   
    echo "| ut      | Utilidad        | Crea una clase simple.                              |"
    echo "-----------------------------------------------------------------------------------"
    echo ""
    echo "Ejemplos:"
    echo "- 1"
    echo "  Comando:" 
    echo "        $0 cf Swagger"  
    echo "  Resultado:" 
    echo "        Crea la clase SwaggerConfig.java en .../config/"
    echo ""
    echo "- 2"
    echo "  Comando:" 
    echo "         $0 sv Producto "
    echo "  Resultado:" 
    echo "         Crea la interface IProductoService y la clase ProductoServiceImpl en .../service/producto"
    exit 0
}

# Mostrar ayuda si se usa --info o sin parametros
if [ "$#" -eq 0 ] || [ "$1" == "--info" ]; then
    show_info
fi

# Validar parametros
if [ "$#" -ne 2 ]; then
    echo "Error: Numero de parametros incorrecto"
    show_info
    exit 1
fi

# Parametros
tipo="$1"
nombre="$2"
current_dir_name=$(basename "$(pwd)")

# Plantillas de archivos
case "$tipo" in
    "rc") # Controller
        folder="controller"
        class_name="${nombre}Controller"
        annotation="@RestController"
        content="package com.${current_dir_name}.controller;\n\n${annotation}\npublic class ${class_name} {\n    // Endpoints aqui\n}"
        ;;
    "dt") # DTO
        folder="dto"
        class_name="${nombre}DTO"
        content="package com.${current_dir_name}.dto;\n\npublic class ${class_name} {\n    // Atributos y metodos aqui\n}"
        ;;
    "rp") # Repository
        folder="repository"
        class_name="I${nombre}Repository"
        content="package com.${current_dir_name}.repository;\n\nimport org.springframework.data.jpa.repository.JpaRepository;\n\npublic interface ${class_name} extends JpaRepository<${nombre}, Long> {\n    // Consultas personalizadas aqui\n}"
        ;;
    "cf") # Config
        folder="config"
        class_name="${nombre}Config"
        content="package com.${current_dir_name}.config;\n\nimport org.springframework.context.annotation.Configuration;\n\n@Configuration\npublic class ${class_name} {\n    // Configuraciones aqui\n}"
        ;;
    "md") # Model
        folder="model"
        class_name="${nombre}"
        content="package com.${current_dir_name}.model;\n\npublic class ${class_name} {\n    // Atributos y metodos aqui\n}"
        ;;
    "ut") # Util
        folder="util"
        class_name="${nombre}Utils"
        content="package com.${current_dir_name}.util;\n\npublic class ${class_name} {\n    // Metodos utilitarios aqui\n}"
        ;;
    "ex") # Exception
        folder="exception"
        class_name="${nombre}Exception"
        content="package com.${current_dir_name}.exception;\n\npublic class ${class_name} extends Exception {\n    public ${class_name}(String message) {\n        super(message);\n    }\n}"
        ;;
    "sv") # Service (crea 2 archivos)
        # Interface
        folder_service="service/${nombre,,}"
        class_service="I${nombre}Service"
        content_service="package com.${current_dir_name}.service.${nombre,,};\n\npublic interface ${class_service} {\n    // Metodos de servicio aqui\n}"
        
        # Implementación
        class_impl="${nombre}ServiceImpl"
        content_impl="package com.${current_dir_name}.service.${nombre,,};\n\nimport org.springframework.stereotype.Service;\n\n@Service\npublic class ${class_impl} implements ${class_service} {\n    // Implementaciones aqui\n}"
        
        # Rutas para service
        target_dir_service="src/main/java/com/${current_dir_name}/${folder_service}"
        target_file_service="${target_dir_service}/${class_service}.java"
        target_file_impl="${target_dir_service}/${class_impl}.java"
        
        # Validar existencia
        if [ -f "$target_file_service" ] || [ -f "$target_file_impl" ]; then
            echo "El archivo existe. No se puede agregar."
            exit 1
        fi
        
        # Crear service + impl
        mkdir -p "$target_dir_service"
        echo -e "$content_service" > "$target_file_service"
        echo -e "$content_impl" > "$target_file_impl"
        
        # Mostrar resultados
        echo ""
        echo "Archivos creados exitosamente:"
        echo "1. Interface: ${target_file_service}"
        echo "2. Implementacion: ${target_file_impl}"
        echo "Contenido:"
        echo "--------------------------------------------------"
        cat "$target_file_service"
        echo ""
        echo "--------------------------------------------------"
        cat "$target_file_impl"
        echo "--------------------------------------------------"
        exit 0
        ;;
    *)
        echo "Error: Tipo '$tipo' no valido"
        show_info
        exit 1
        ;;
esac

# Ruta del archivo (para todos los tipos excepto service)
target_dir="src/main/java/com/${current_dir_name}/${folder}"
target_file="${target_dir}/${class_name}.java"

# Validar si el archivo existe (NO sobrescribir)
if [ -f "$target_file" ]; then
    echo "El archivo existe. No se puede agregar: $target_file"
    exit 1
fi

# Crear directorios y archivo
mkdir -p "$target_dir"
echo -e "$content" > "$target_file"

# Resultado
echo ""
echo "Archivo creado exitosamente:"
echo "Ubicacion: ${target_file}"
echo "Contenido:"
echo "--------------------------------------------------"
cat "$target_file"
echo "--------------------------------------------------"