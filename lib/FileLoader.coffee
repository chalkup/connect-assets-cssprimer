fs = require "fs"
path = require "path"

watchr = require "watchr"

class FileLoader
  constructor: (@assetsModule, @log, skipHidden) ->
    @assets = assetsModule.instance
    @assetCSS = @assets.options.helperContext.css
    @cssFilesRoot = path.join @assets.options.src, @assetCSS.root

  loadFiles: ->
    @_loadCSSFileOrDirectory @cssFilesRoot

  _loadCSSDirectory: (dirPath) ->
    paths = fs.readdirSync dirPath
  
    @_loadCSSFileOrDirectory path.join(dirPath, filePath) for filePath in paths
    true

  _loadCSSFileOrDirectory: (sourcePath) ->
    stat = fs.statSync sourcePath
    if stat?.isDirectory()
      @_loadCSSDirectory sourcePath
    else    
      # Get the relative path to the cssFilesRoot
      assetName = path.relative @cssFilesRoot, sourcePath

      # Remove the extension from the file
      assetName = assetName.replace path.extname(assetName), ''

      # Remove all the compiler extensions
      for ext, compiler of @assetsModule.cssCompilers
        assetName = assetName.replace ".#{ext}", ''

      # Skip if a hidden file
      return if "." is path.basename(assetName).slice(0, 1)

      # connet-assets will not route correctly with '\' in the name.
      # Replacing them to so that connect-assets will have the correct c
      assetName = assetName.replace /\\/g, '/'

      @log?("Assetizing #{assetName}")
      @assetCSS assetName

  watchFiles: (fileChangedCallback, done) ->

    watchOptions = 
      # Watch our js root
      path: @cssFilesRoot

      # When a file is changed, run this
      listener: (evt, filePath, fileStat, filePrevStat) =>
        @_loadCSSFileOrDirectory filePath
        fileChangedCallback?(null, filePath)
      
      # Wait til we're ready before continuing
      next: (err, watchr) ->
        done(err, watchr)

    # Let's light this candle
    watchr.watch watchOptions

module.exports = FileLoader
