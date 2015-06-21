# encoding: UTF-8
require "prawn"
require "csv"

class Documento < Prawn::Document
  PDF_PATH = File.expand_path("../pdf", __FILE__)

  def initialize
    super(top_margin: 70)
    
    municipios = []
    CSV.foreach("./cidades.csv", headers: true) do |row|
      municipios << { nome: row[0], messoregiao: row[1], microregiao: row[2], porte: row[3]}
    end

    text "This is the first page!"
    gerar_titulo(municipios)

    string = "Página <page>"
    options = { 
          :at => [bounds.right - 150, 0],
              :width => 150,
              :align => :right,
              :start_count_at => 1,
              :color => "000000" }
    number_pages string, options
  end

  def gerar_documento
    render_file "#{Documento::PDF_PATH}/documento.pdf"
  end

  private

  def gerar_titulo(municipios)
    municipios.each do |municipio|
      dados = []
      dados << { chave: "Município",    valor: municipio[:nome] }
      dados << { chave: "Mesorregião",  valor: municipio[:messoregiao] }
      dados << { chave: "Microrregião", valor: municipio[:microregiao] }
      dados << { chave: "Porte",        valor: municipio[:porte] }

      start_new_page
      dados.each do |dado|
        font("Helvetica", size: 14) do 
          text "<b>#{dado[:chave]}:</b> #{dado[:valor]}",  inline_format: true
        end
        move_down 2
      end
    end
  end
end

documento = Documento.new
documento.gerar_documento