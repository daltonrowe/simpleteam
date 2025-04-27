# frozen_string_literal: true

class Abstract::NavigatorComponent < ViewComponent::Base
  def classes
    case style
    when :filled
      filled_classes
    when :outlined
      outlined_classes
    end
  end

  def filled_classes
    classes_array = [ "w-full", "sm:w-auto", "text-center", "rounded-md", "px-3.5", "py-2.5", "", "inline-block", "font-medium", "cursor-pointer" ]

    classes_array.push("bg-white", "hover:bg-gray-100", "text-red-500") if level == :primary
    classes_array.push("bg-gray-100", "hover:bg-gray-100", "text-yin-900") if level == :secondary

    classes_array << extra_classes if extra_classes

    classes_array.join(" ")
  end

  def outlined_classes
    classes_array = [ "w-full", "sm:w-auto", "text-center", "rounded-md", "px-3.5", "py-2.5", "", "inline-block", "font-medium", "cursor-pointer" ]

    classes_array.push("border-1", "hover:bg-yin-800", "text-red-500") if level == :primary
    classes_array.push("border-1", "hover:bg-yin-800", "text-yin-400") if level == :secondary

    classes_array << extra_classes if extra_classes

    classes_array.join(" ")
  end
end
