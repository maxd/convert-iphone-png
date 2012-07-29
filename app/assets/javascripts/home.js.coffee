class Uploader
  constructor: (@fileElement) ->
    @fileElement.change(fileElementChanged)

  fileElementChanged = ->
    correct_files = _(this.files).select (f) -> isValidFileType(f) && isValidFileSize(f)

    if correct_files.length != this.files.length
      alert 'Some files will be ignore. You can upload PNG or IPA files with size less 50 MB'

    uploadFile(correct_files)

  isValidFileType = (file) ->
    /\.(png|ipa)$/.test(file.name)

  isValidFileSize = (file) ->
    file.size < 50 * 1024 * 1024

  uploadFile = (files) ->
    data = new FormData()
    _(files).each (f) -> data.append('files[]', f)

    $('.result').html("<div class='loading'>Please wait. Conversion can take several minutes...</div>")

    $.ajax
      url: '/upload'
      type: 'POST'
      data: data
      cache: false
      contentType: false
      processData: false
      success: (data) ->
        $('.result').html(data)
      error: (xhr, textStatus, errorThrown) ->
        $('.result').html("<div class='alert alert-error'>Internal error. Try again later.</div>")

window.uploader = new Uploader $("#files")