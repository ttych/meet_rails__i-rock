class SerializableAchievement < JSONAPI::Serializable::Resource
  type 'achievement'

  attributes :id, :title

  attribute :date do
    @object.created_at
  end
end
