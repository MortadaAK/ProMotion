motion_require '../screen/screen_module'
module ProMotion
  if defined?(Formotion) && defined?(Formotion::FormController)
    class FormotionScreen < Formotion::FormController
      include ProMotion::ScreenModule

      def self.new(args = {})
        s = self.alloc.initWithStyle(UITableViewStyleGrouped)
        s.on_create(args) if s.respond_to?(:on_create)

        if s.respond_to?(:table_data)
          s.form = s.table_data
        elsif args[:form]
          s.form = args[:form]
        else
          PM.logger.error "PM::FormotionScreen requires a `table_data` method or form: to be passed into `new`."
        end

        s.tableView.allowsSelectionDuringEditing = true
        s.after_setup

        s
      end

      # emulate the ProMotion table update for formotion
      def update_table_data
        self.form            = table_data
        self.form.controller = self
        self.tableView.reloadData
        self.after_setup
      end

      def screen_setup
        self.title = self.class.send(:get_title)
      end

      def after_setup
        self.title = self.class.send(:get_title) # Formotion kills the title when you request tableView.
        self.bind_submit # bind submit action after populating table data
      end

      def bind_submit
        self.form.on_submit { |form| self.on_submit(form) if self.respond_to?(:on_submit) }
      end

      def loadView
        super
        self.send(:on_load) if self.respond_to?(:on_load)
      end

      def viewDidLoad
        super
        self.view_did_load if self.respond_to?(:view_did_load)
      end

      def viewWillAppear(animated)
        super
        self.view_will_appear(animated) if self.respond_to?("view_will_appear:")
      end

      def viewDidAppear(animated)
        super
        self.view_did_appear(animated) if self.respond_to?("view_did_appear:")
      end

      def viewWillDisappear(animated)
        self.view_will_disappear(animated) if self.respond_to?("view_will_disappear:")
        super
      end

      def viewDidDisappear(animated)
        if self.respond_to?("view_did_disappear:")
          self.view_did_disappear(animated)
        end
        super
      end

      def shouldAutorotateToInterfaceOrientation(orientation)
        self.should_rotate(orientation)
      end

      def shouldAutorotate
        self.should_autorotate
      end

      def willRotateToInterfaceOrientation(orientation, duration:duration)
        self.will_rotate(orientation, duration)
      end

      def didRotateFromInterfaceOrientation(orientation)
        self.on_rotate
      end
    end
  end
end
