###
	FlexNav.js 0.8

	Copyright 2013, Jason Weaver http://jasonweaver.name
	Released under the WTFPL license
	http://sam.zoy.org/wtfpl/

//
###

$.fn.flexNav = (options) ->
	settings = $.extend
		'animationSpeed': 100
		options
			
	$nav = $(@)
	nav_open = false
	isDragging = false
	
	# Set some classes in the markup
	$nav.find("li").each ->
		if $(@).has("ul").length
			$(@).addClass("item-with-ul").find("ul").hide()
	
	if $nav.data('breakpoint') then breakpoint = $nav.data('breakpoint')
	
	resizer = ->
		if $(window).width() <= breakpoint
			$nav.removeClass("lg-screen").addClass("sm-screen")
			# Toggle nav menu closed for one pager after anchor clicked
			$('.one-page li a').on( 'click', ->
				$nav.removeClass('show')
			)
			$('.item-with-ul').off()
		else
			$nav.removeClass("sm-screen").addClass("lg-screen")
			$nav.removeClass('show')
			$('.item-with-ul').on('mouseenter', ->
				$(@).find('>ul').addClass('show').stop(true, true).slideDown(settings.animationSpeed)
			).on('mouseleave', ->
				$(@).find('>ul').removeClass('show').stop(true, true).slideUp(settings.animationSpeed)	
			)
		
	# Add in touch buttons	
	$('.item-with-ul, .menu-button').append('<span class="touch-button"><i class="navicon">&#9660;</i></span>')

	# Toggle touch for nav menu
	$('.menu-button, .menu-button .touch-button').on('touchstart mousedown', (e) ->
		e.preventDefault()
		e.stopPropagation()
		console.log(isDragging)
		$(@).on( 'touchmove mousemove', (e) ->
			msg = e.pageX
			isDragging = true
			$(window).off("touchmove mousemove")
		)		
	).on('touchend mouseup', (e) ->
		e.preventDefault()
		e.stopPropagation()
		isDragging = false
		$parent = $(@).parent()
		if isDragging is false
    	console.log('clicked')
			if nav_open is false
				$nav.addClass('show')
				nav_open = true
			else if nav_open is true
				$nav.removeClass('show')			
				nav_open = false
		)
			
				
	# Toggle for sub-menus
	$('.touch-button').on('touchstart mousedown', (e) ->
		e.stopPropagation()
		e.preventDefault()
		$(@).on( 'touchmove mousemove', (e) ->
			isDragging = true
			$(window).off("touchmove mousemove")
		)
	).on('touchend mouseup', (e) ->
		e.preventDefault()
		e.stopPropagation()
		$sub = $(@).parent('.item-with-ul').find('>ul')
		# remove class of show from all elements that are not current
		if $nav.hasClass('lg-screen') is true
			$(@).parent('.item-with-ul').siblings().find('ul.show').removeClass('show').hide()
		# add class of show to current
		if $sub.hasClass('show') is true
			$sub.removeClass('show').slideUp(settings.animationSpeed)
		else if $sub.hasClass('show') is false
			$sub.addClass('show').slideDown(settings.animationSpeed)	
	)
	
	# Sub ul's should have a class of 'open' if an element has focus
	$('.item-with-ul *').focus ->
		# remove class of open from all elements that are not focused
		$(@).parent('.item-with-ul').parent().find(".open").not(@).removeClass("open").hide()
		# add class of open to focused ul
		$(@).parent('.item-with-ul').find('>ul').addClass("open").show()

	# Call once to set		
	resizer()

	# Call on browser resize	
	$(window).on('resize', resizer);
