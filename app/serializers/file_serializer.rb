class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :filename, :file_url

  def file_id
    object.blob.id
  end

  def filename
    object.blob.filename
  end

  def file_url
    rails_blob_path(object, host: host_with_port)
  end

  private

  def host_with_port
    url_opt = Rails.application.routes.default_url_options
    "#{url_opt[:host]}#{url_opt[:port]}"
  end
end
