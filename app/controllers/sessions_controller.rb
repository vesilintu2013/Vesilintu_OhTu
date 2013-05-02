class SessionsController < ApplicationController
  require 'xml'
  require 'openssl'
  require 'base64'

  skip_before_filter :check_auth, :only => [:new, :create, :auth_login]

  def new
  end

  def create
    if params[:password] == ADMIN_PASSWORD
      session[:logged_in] = true
    end
    redirect_to root_path
  end

  def auth_login
    if check_data?(parse_xml(decrypt_data))
      session[:logged_in] = true
    end
    redirect_to root_path
  end

  def logout
    session[:logged_in] = nil
    redirect_to new_session_path
  end

  private

  def parse_xml data
    output = {}
    doc = XML::Parser.string(data).parse
    output[:type] = doc.child["type"]
    doc.child.children.each do |child|
      output[child.name.to_sym] = child.content
    end
    output
    
  end

  def check_data? hash
    hash[:type] == "admin" && hash[:auth_for] == 'vesilintu'
  end
  def decrypt_data
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.key = public_key.public_decrypt(Base64.decode64(params[:key]))
    cipher.iv = public_key.public_decrypt(Base64.decode64(params[:iv]))
    data = cipher.update(Base64.decode64(params[:data]))
    data << cipher.final
  end

  def public_key
    OpenSSL::PKey::RSA.new(File.read(Rails.root.join(PUBLIC_KEY_NAME)))
  end
end
