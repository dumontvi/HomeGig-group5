class Notification < ApplicationRecord
    belongs_to :from_user class_name: "Users"
    belongs_to :to_user class_name: "Users"
end
