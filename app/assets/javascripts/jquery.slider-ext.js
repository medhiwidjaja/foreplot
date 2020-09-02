/*
 * jQuery UI Slider Range extension 0.5 
 * Author: Medhi Widjaja
 * Extended to include new range option "zero-based"

 * Licensed under the terms of the MIT and GPL-2.0 license
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/GPL-2.0
 *
 */
 
(function($) {
    if ($.ui.slider)
    {
    	$.extend($.ui.slider.prototype, {
				_refreshValue: function() {
					var lastValPercent, valPercent, value, valueMin, valueMax,
						oRange = this.options.range,
						o = this.options,
						that = this,
						animate = ( !this._animateOff ) ? o.animate : false,
						_set = {},
						leftPos,
						rangePercent;
			
					if ( this._hasMultipleValues() ) {
						this.handles.each( function( i ) {
							valPercent = ( that.values( i ) - that._valueMin() ) / ( that._valueMax() -
								that._valueMin() ) * 100;
							_set[ that.orientation === "horizontal" ? "left" : "bottom" ] = valPercent + "%";
							$( this ).stop( 1, 1 )[ animate ? "animate" : "css" ]( _set, o.animate );
							if ( that.options.range === true ) {
								if ( that.orientation === "horizontal" ) {
									if ( i === 0 ) {
										that.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
											left: valPercent + "%"
										}, o.animate );
									}
									if ( i === 1 ) {
										that.range[ animate ? "animate" : "css" ]( {
											width: ( valPercent - lastValPercent ) + "%"
										}, {
											queue: false,
											duration: o.animate
										} );
									}
								} else {
									if ( i === 0 ) {
										that.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
											bottom: ( valPercent ) + "%"
										}, o.animate );
									}
									if ( i === 1 ) {
										that.range[ animate ? "animate" : "css" ]( {
											height: ( valPercent - lastValPercent ) + "%"
										}, {
											queue: false,
											duration: o.animate
										} );
									}
								}
							}
							lastValPercent = valPercent;
						} );
					} else {
						value = this.value();
						valueMin = this._valueMin();
						valueMax = this._valueMax();
						valPercent = ( valueMax !== valueMin ) ?
								( value - valueMin ) / ( valueMax - valueMin ) * 100 :
								0;
						rangePercent = ( valueMax !== valueMin ) ?
								Math.abs( value ) / ( valueMax - valueMin ) * 100 :
								0;
						leftPos = ( value > 0 ) ? 
								Math.abs( valueMin ) / ( valueMax - valueMin ) * 100 :
								Math.abs ( value - valueMin ) / ( valueMax - valueMin ) * 100;
						_set[ this.orientation === "horizontal" ? "left" : "bottom" ] = valPercent + "%";
						this.handle.stop( 1, 1 )[ animate ? "animate" : "css" ]( _set, o.animate );
			
						if ( oRange === "min" && this.orientation === "horizontal" ) {
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
								width: valPercent + "%"
							}, o.animate );
						}
						if ( oRange === "max" && this.orientation === "horizontal" ) {
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
								width: ( 100 - valPercent ) + "%"
							}, o.animate );
						}
						if ( oRange === "min" && this.orientation === "vertical" ) {
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
								height: valPercent + "%"
							}, o.animate );
						}
						if ( oRange === "max" && this.orientation === "vertical" ) {
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( {
								height: ( 100 - valPercent ) + "%"
							}, o.animate );
						}
						if ( oRange === "zero-based" && this.orientation === "horizontal" ) {
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( { width: rangePercent + "%" }, o.animate ); 
							this.range.stop( 1, 1 )[ animate ? "animate" : "css" ]( { left: leftPos + "%" }, o.animate );
						}
					}
				}
		})
	}
})(jQuery);
