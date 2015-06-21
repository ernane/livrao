# encoding: utf-8
require "prawn"

class Documento < Prawn::Document
	PDF_PATH = File.expand_path("../pdf", __FILE__)

	def initialize
		super(top_margin: 70)

  	text "This is the first page!"

  	144.times do
    	start_new_page
    	text "Here comes yet another page."
  	end

  	string = "page <page> of <total>"
  	
  	# Green page numbers 1 to 7
  	options = { 
  			  :at => [bounds.right - 150, 0],
              :width => 150,
              :align => :right,
              :page_filter => (1..7),
              :start_count_at => 1,
              :color => "007700" }
  	number_pages string, options

  # Gray page numbers from 8 on up
  options[:page_filter]    = lambda{ |pg| pg > 7 }
  options[:start_count_at] = 8
  options[:color]          = "333333"
  number_pages string, options

  start_new_page
  text "See. This page isn't numbered and doesn't count towards the total."
	end

	def create
		render_file "#{Documento::PDF_PATH}/documento.pdf"
	end
end

documento = Documento.new
documento.create
