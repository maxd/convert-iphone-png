class Uploader
  constructor: ->
    $("#files").change(fileElementChanged)

    $('#upload-files').submit ->
      return false;

  fileElementChanged = ->
    correct_files = _(this.files).select (f) -> isValidFileType(f) && isValidFileSize(f)

    if correct_files.length != this.files.length
      alert 'Some files will be ignore. You can upload PNG files with size less 50 MB'

    uploadFile(correct_files)

  isValidFileType = (file) ->
    /\.(png)$/.test(file.name)

  isValidFileSize = (file) ->
    file.size < 50 * 1024 * 1024

  uploadFile = (files) ->
    $('.result').html("<div class='loading'></div>")

    $('#upload-files').ajaxSubmit
      target: '.result'
      resetForm: true
      uploadProgress: (e, position, total, percentComplete) ->
        message = if percentComplete != 100 then 'Please wait. Uploading files...' else 'Please wait. Conversion can take several minutes...'
        $('.loading').text(message)
      error: ->
        $('.result').html("<div class='alert alert-error'>Internal error. Try again later.</div>")

window.uploader = new Uploader