class LibrariesController < ApplicationController
  def overview
    @library = Library.where(:library_id => params[:id]).first!
    @sample = @library.sample
  end
end
