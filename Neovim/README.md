# Configuraciones de programas

Repositorio personal de configuraciones reutilizables. Incluye el entorno de **Neovim + LaTeX + SumatraPDF** para Windows.

## Estructura sugerida

```text
configuraciones/
├── neovim/
│   └── init.lua
├── sumatrapdf/
│   └── sumatra-neovim.ps1
└── README.md
```

> **Importante:** `README.md` documenta la instalación; **no reemplaza** a `init.lua` ni al script de PowerShell. Copiar los archivos originales a este repositorio, sin moverlos de su ubicación de trabajo.

## Requisitos de la otra computadora

- [Neovim](https://neovim.io/)
- [Git](https://git-scm.com/), para descargar la configuración y sus complementos
- [TeX Live](https://www.tug.org/texlive/) con `latexmk`, XeLaTeX y los paquetes LaTeX que use el proyecto
- [SumatraPDF](https://www.sumatrapdfreader.org/)
- Python y el paquete `neovim-remote` (`nvr`), **si se desea sincronización inversa desde SumatraPDF**
- Opcional: fuente JetBrains Mono en la terminal

## 1. Recuperar la configuración de Neovim

1. Copiar `neovim/init.lua` a:

   ```text
   %LOCALAPPDATA%\nvim\init.lua
   ```

   Si la carpeta no existe, crearla. Se puede abrir mediante `Win + R` y `%LOCALAPPDATA%\nvim`.

2. Revisar las rutas específicas de la computadora **antes de iniciar**:

   - Directorio de trabajo predeterminado:

     ```lua
     vim.api.nvim_set_current_dir("F:/LATEX/neovim")
     ```

     Cambiarlo por la carpeta donde se encontrará el proyecto, y asegurarse de que exista.

   - Ruta de SumatraPDF en la configuración `vim.g.vimtex_view_general_viewer`. La instalación puede estar en una ubicación diferente.

   - Nombre de la tubería de Neovim para `nvr`: `\\.\pipe\nvim-sumatra`. El `init.lua` actual crea ese servidor; la invocación desde PowerShell tiene que usar el mismo nombre.

3. Iniciar Neovim. `lazy.nvim` gestionará los complementos declarados en `init.lua`; si hace falta, ejecutar:

   ```vim
   :Lazy sync
   ```

4. Reiniciar Neovim.

### Complementos configurados

- **VimTeX**, fijado a la versión `v2.17` en la configuración utilizada.
- **nvim-tree.lua**, explorador de archivos lateral que reemplaza a `netrw`.
- **nvim-web-devicons**, iconos del explorador.
- **nvim-scrollview**, barras de desplazamiento.
- **Unokai**, tema de colores. Si no está disponible en la otra PC, hay que instalar/copiar su archivo de tema por separado: el `init.lua` actual lo selecciona, pero no lo declara como complemento de Lazy.

La configuración también incluye `wrap` y `linebreak` (ajuste visual sin cortar palabras), portapapeles de Windows, barra de estado por modo y opciones de recuperación (`swapfile`, `undofile` y `writebackup`).

## 2. Compilar LaTeX

Abrir Git Bash en la carpeta **real** del proyecto, donde se encuentra el archivo principal. Por ejemplo:

```bash
cd /f/LATEX/neovim
latexmk -xelatex -synctex=1 -pvc -time general.tex
```

- `-xelatex`: utiliza XeLaTeX.
- `-synctex=1`: genera los datos de sincronización con el PDF.
- `-pvc`: recompila al detectar cambios guardados; detener con `Ctrl+C`.
- `-time`: muestra tiempos de ejecución.

La carpeta de Neovim **no determina** la de Git Bash: hay que entrar a la ubicación del proyecto en la terminal, o utilizar `latexmk -cd` con una ruta completa.

> Si el proyecto utiliza LuaLaTeX, reemplazar `-xelatex` por `-lualatex`. Mantener el motor de compilación consistente con el proyecto.

## 3. Sincronización con SumatraPDF

### Desde Neovim hacia el PDF

Con un archivo `.tex` abierto, pulsar **F5** para ejecutar `:VimtexView` y localizar el texto en SumatraPDF. Comprobar que la ruta del ejecutable de SumatraPDF sea correcta y que el PDF esté compilado con `-synctex=1`.

### Desde SumatraPDF hacia Neovim

1. Copiar `sumatrapdf/sumatra-neovim.ps1` a la ubicación elegida, por ejemplo:

   ```text
   C:\Users\USUARIO\sumatra-neovim.ps1
   ```

2. Instalar Python y `neovim-remote` si todavía no están disponibles:

   ```powershell
   py -m pip install neovim-remote
   ```

3. En **SumatraPDF → Configuración → Opciones**, configurar la búsqueda inversa con la ruta real del script (ajustar `USUARIO`):

   ```text
   powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\USUARIO\sumatra-neovim.ps1" "%f" %l
   ```

4. Verificar que el script usa el mismo servidor que creó Neovim (`\\.\pipe\nvim-sumatra`). El script debe existir y `nvr` debe estar accesible desde PowerShell.

5. Probar con doble clic sobre el texto del PDF, que debería llevar a la línea correspondiente de Neovim.

## 4. Comprobaciones rápidas

- [ ] Neovim inicia sin mensajes de error.
- [ ] Se abre **nvim-tree** a la izquierda.
- [ ] Se pueden abrir varios capítulos con el mouse sin congelamientos.
- [ ] Se muestran las barras de `nvim-scrollview`.
- [ ] Las líneas largas se ajustan sin cortar palabras.
- [ ] `:%y+` copia al portapapeles de Windows.
- [ ] `:VimtexView` funciona en archivos `.tex` y **F5** localiza el texto en el PDF.
- [ ] El PDF se actualiza al guardar un `.tex` mientras `latexmk -pvc` está activo.
- [ ] El doble clic en SumatraPDF localiza el texto de origen en Neovim.

## 5. Guardar cambios en GitHub

Si trabajás sobre una copia local de este repositorio:

```bash
git status
git add README.md neovim/init.lua sumatrapdf/sumatra-neovim.ps1
git diff --cached --stat
git commit -m "Documentar configuracion de Neovim y SumatraPDF"
git push
```

Los comandos `git add` suponen que esos archivos ya existen en las carpetas indicadas y que el repositorio está vinculado con GitHub. Nunca subir contraseñas, tokens o archivos confidenciales.

---

**Nota:** esta guía reproduce una configuración personal y requiere adaptar las rutas de usuario, proyectos y programas al equipo nuevo.
