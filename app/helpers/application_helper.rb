module ApplicationHelper

    def link_filter_hashtag tag
        @ids = hashtag_ids.clone
        if @ids.include?(tag.id)
            @ids.reject!{ |a| a == tag.id }
            @ids = [0] if @ids.count == 0
        else
            @ids << tag.id
        end
        return @ids
    end
end
