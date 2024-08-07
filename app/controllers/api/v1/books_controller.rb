class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    books = Book.all
    render json: books.map { |book| book_data(book) }
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: book_data(book), status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: book_data(@book)
  end

  def update
    if @book.update(book_params)
      render json: book_data(@book)
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :image)
  end

  def book_data(book)
    data = book.as_json
    if book.image.attached?
      data['image_url'] = rails_blob_path(book.image, only_path: true)
    end
    data
  end
end
