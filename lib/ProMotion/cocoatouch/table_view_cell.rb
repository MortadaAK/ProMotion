motion_require '../table/cell/table_view_cell_module'
module ProMotion
  class TableViewCell < UITableViewCell
    include TableViewCellModule

    attr_accessor :image_size

    # TODO: Is this necessary?
    def layoutSubviews
      super

      if self.image_size && self.imageView.image && self.imageView.image.size && self.imageView.image.size.width > 0
        f = self.imageView.frame
        size_inset_x = (self.imageView.size.width - self.image_size) / 2
        size_inset_y = (self.imageView.size.height - self.image_size) / 2
        self.imageView.frame = CGRectInset(f, size_inset_x, size_inset_y)
      end
    end
  end
end
