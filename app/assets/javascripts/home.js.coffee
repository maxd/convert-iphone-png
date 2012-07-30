class Uploader
  constructor: ->
    $("#files").change(fileElementChanged)

    $('#upload-files').submit ->
      return false;

  fileElementChanged = ->
    uploadFile()

  uploadFile = () ->
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