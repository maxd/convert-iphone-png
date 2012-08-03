class Uploader
  constructor: ->
    $("#files").change(fileElementChanged)

    $('#upload-files').submit ->
      return false;

  fileElementChanged = ->
    if this.files.length > 50
      $('.result').html("<div class='alert alert-warning'>You can't upload more than 50 files per time.</div>")
      return

    uploadFile()

  uploadFile = () ->
    $('.result').html("<div class='loading'></div>")

    $('#upload-files').ajaxSubmit
      target: '.result'
      resetForm: true
      uploadProgress: (e, position, total, percentComplete) ->
        message = if percentComplete != 100 then 'Please wait. Uploading files...' else 'Please wait. Conversion can take several minutes...'
        $('.loading').html('<div class="alert alert-info">' + message + '</div>')
      error: ->
        $('.result').html("<div class='alert alert-error'>Internal error. Try again later.</div>")

window.uploader = new Uploader