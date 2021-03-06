<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="exslt str">

<!-- render-image -->
	<xsl:template name="render-image">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="ratio" select="''" />
		<xsl:param name="format" select="''" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:variable name="computed-attr">
			<xsl:choose>
				<!-- Svg File -->
				<xsl:when test="exslt:object-type($image) = 'node-set' and (contains($image/@type, 'svg') or contains($image/@type, 'gif') or contains($image/@type, 'tiff'))">

					<add src="/workspace{$image/@path}/{$image/filename}" />
				</xsl:when>

				<!-- Img File -->
				<xsl:otherwise>
					<add>
						<xsl:attribute name="src">
							<xsl:call-template name="render-image-src">
								<xsl:with-param name="image" select="$image" />
								<xsl:with-param name="factor" select="$factor" />
								<xsl:with-param name="ratio" select="$ratio" />
								<xsl:with-param name="use-format" select="string-length($format) != 0" />
							</xsl:call-template>
						</xsl:attribute>
					</add>

					<xsl:if test="string-length($format) != 0 and exslt:object-type($image) = 'node-set' and count($image/filename) = 1">
						<add data-src-format="{$format}{$image/@path}/{$image/filename}" />
						<add>
							<xsl:attribute name="data-src-original" >
								<xsl:call-template name="render-image-src">
									<xsl:with-param name="image" select="$image" />
									<xsl:with-param name="use-format" select="false()" />
								</xsl:call-template>
							</xsl:attribute>
						</add>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<add alt="~'{$alt}'" />
			<xsl:copy-of select="$attr" />
		</xsl:variable>

		<img>
			<xsl:call-template name="attr">
				<xsl:with-param name="attr" select="$computed-attr" />
			</xsl:call-template>
		</img>
	</xsl:template>

<!-- render-image-crop -->
	<xsl:template name="render-image-crop">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'$h'" />
		<xsl:param name="position" select="'5'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:variable name="computed-format" >
			<xsl:text>/image/2/</xsl:text>
			<xsl:value-of select="concat($width, '/')" />
			<xsl:value-of select="concat($height, '/')" />
			<xsl:value-of select="$position" />
		</xsl:variable>

		<xsl:call-template name="render-image">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="format" select="$computed-format" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-crop-ratio -->
	<xsl:template name="render-image-crop-ratio">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'8'" />
		<xsl:param name="ratio" select="''" />
		<xsl:param name="position" select="'5'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:variable name="computed-format">
			<xsl:text>/image/2/$w/$</xsl:text>
			<xsl:value-of select="$ratio" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$position" />
		</xsl:variable>

		<xsl:call-template name="render-image">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="ratio" select="$ratio" />
			<xsl:with-param name="format" select="$computed-format" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-crop-3_4 -->
	<xsl:template name="render-image-crop-3_4">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'8'" />
		<xsl:param name="position" select="'5'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:call-template name="render-image-crop-ratio">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="ratio" select="'3/4'" />
			<xsl:with-param name="position" select="$position" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-crop-9_16 -->
	<xsl:template name="render-image-crop-9_16">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'8'" />
		<xsl:param name="position" select="'5'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:call-template name="render-image-crop-ratio">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="ratio" select="'9/16'" />
			<xsl:with-param name="position" select="$position" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>
	
<!-- render-image-resize -->
	<xsl:template name="render-image-resize">
		<xsl:param name="image" select="image" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'0'" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:variable name="computed-format">
			<xsl:text>/image/1/</xsl:text>
			<xsl:value-of select="concat($width, '/')" />
			<xsl:value-of select="$height" />
		</xsl:variable>

		<xsl:variable name="computed-attr">
			<xsl:choose>
				<xsl:when test="$width = '$w' and $height != '$h'">
					<add class="block width-full" />
				</xsl:when>
				<xsl:when test="$height = '$h' and $width != '$w'">
					<add class="block height-full" />
				</xsl:when>
			</xsl:choose>

			<xsl:copy-of select="$attr" />
		</xsl:variable>

		<xsl:call-template name="render-image">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="format" select="$computed-format" />
			<xsl:with-param name="attr" select="$computed-attr" />
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-fit -->
	<xsl:template name="render-image-fit">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'$h'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:variable name="computed-format">
			<xsl:text>/image/4/</xsl:text>
			<xsl:value-of select="concat($width, '/')" />
			<xsl:value-of select="$height" />
		</xsl:variable>

		<xsl:call-template name="render-image">
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="format" select="$computed-format" />
			<xsl:with-param name="attr" select="$attr"/>
			<xsl:with-param name="alt" select="$alt" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-bg -->
	<xsl:template name="render-image-bg">
		<xsl:param name="position" />
		<xsl:param name="size" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'0'" />
		<xsl:param name="image" select="image" />
		<xsl:param name="image-attr" />
		<xsl:param name="factor" select="'1'" />
		<xsl:param name="element" select="'figure'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>
		
	<!-- Computed value -->
		<xsl:variable name="img-path">
			<xsl:choose>
				<xsl:when test="exslt:object-type($image) = 'node-set' and (contains($image/@type, 'svg') or contains($image/@type, 'gif') or contains($image/@type, 'tiff'))">
					<xsl:value-of select="concat('/workspace', $image/@path, '/', $image/filename)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>/image/1/</xsl:text>
					<xsl:value-of select="round($image/meta/@width div $factor)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="round($image/meta/@height div $factor)" />
					<xsl:value-of select="$image/@path" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$image/filename" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="pos">
			<xsl:choose>
				<xsl:when test="string-length($position) != 0">
					<xsl:value-of select="$position" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>50% 50%</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="computed-format">
			<xsl:text>/image/1/</xsl:text>
			<xsl:value-of select="concat($width, '/')" />
			<xsl:value-of select="$height" />
		</xsl:variable>
	<!-- /-->

	<!-- Computed attributes -->
		<xsl:variable name="style-attr">
			<add>
				<xsl:attribute name="style">

					<!--add background-url -->
					<xsl:text>background-image:url('</xsl:text>
					<xsl:value-of select="$img-path" />
					<xsl:text>');</xsl:text>

					<!-- Force no repeat -->
					<xsl:text>background-repeat:no-repeat;</xsl:text>

					<!-- Add position -->
					<xsl:value-of select="concat('background-position:', $pos, ';')" />

					<!-- Add site -->
					<xsl:if test="string-length($size) != 0">
						<xsl:value-of select="concat('background-size:', $size, ';')" />
					</xsl:if>
				</xsl:attribute>
			</add>
		</xsl:variable>

		<xsl:variable name="computed-attr">
			<xsl:copy-of select="$style-attr" />
			<xsl:copy-of select="$attr"/>
			<add class="jit-image-bg" />
			<add dev-core="render-image-bg" />
		</xsl:variable>

		<xsl:variable name="computed-image-bg-attr">
			<add class="jit-image-bg-src hidden" />
			<xsl:copy-of select="$image-attr" />
			<add dev-core-element="image" />
		</xsl:variable>

		<xsl:call-template name="element">
			<xsl:with-param name="element" select="$element"/>
			<xsl:with-param name="attr" select="$computed-attr"/>
			<xsl:with-param name="content">
				
				<xsl:call-template name="render-image">
					<xsl:with-param name="attr" select="$computed-image-bg-attr" />
					<xsl:with-param name="image" select="$image" />
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="factor" select="$factor" />
					<xsl:with-param name="format" select="$computed-format" />
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

<!-- render-image-bg-cover -->
	<xsl:template name="render-image-bg-cover">
		<xsl:param name="position" select="'50% 50%'" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'0'" />
		<xsl:param name="image" select="image" />
		<xsl:param name="image-attr" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="element" select="'figure'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:call-template name="render-image-bg">
			<xsl:with-param name="position" select="$position" />
			<xsl:with-param name="size" select="'cover'" />
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="image-attr" select="$image-attr" />
			<xsl:with-param name="element" select="$element" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="alt" select="$alt" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
		</xsl:call-template>
	</xsl:template>
	
<!-- render-image-bg-contain -->
	<xsl:template name="render-image-bg-contain">
		<xsl:param name="position" select="'50% 50%'" />
		<xsl:param name="width" select="'$w'" />
		<xsl:param name="height" select="'0'" />
		<xsl:param name="image" select="image" />
		<xsl:param name="image-attr" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="element" select="'figure'" />
		<xsl:param name="attr" />
		<xsl:param name="alt">
			<xsl:call-template name="default-image-alt-selector" />
		</xsl:param>

		<xsl:call-template name="render-image-bg">
			<xsl:with-param name="position" select="$position" />
			<xsl:with-param name="size" select="'contain'" />
			<xsl:with-param name="image" select="$image" />
			<xsl:with-param name="image-attr" select="$image-attr" />
			<xsl:with-param name="alt" select="$alt" />
			<xsl:with-param name="element" select="$element" />
			<xsl:with-param name="attr" select="$attr" />
			<xsl:with-param name="factor" select="$factor" />
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
		</xsl:call-template>
	</xsl:template>

<!-- render-image-src -->
	<xsl:template name="render-image-src">
		<xsl:param name="image" select="image" />
		<xsl:param name="factor" select="'3'" />
		<xsl:param name="ratio" select="''" />
		<xsl:param name="use-format" select="true()" />
		
		<xsl:variable name="parsed-ratio">
			<xsl:choose>
				<xsl:when test="string-length($ratio) = 0"></xsl:when>
				<xsl:when test="number($ratio) = $ratio">
					<xsl:value-of select="$ratio" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="ratio-tokens" select="str:tokenize($ratio, '/')" />
					<xsl:choose>
						<xsl:when test="count($ratio-tokens) = 2">
							<xsl:value-of select="number($ratio-tokens[1]) div number($ratio-tokens[2])" />
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="exslt:object-type($image) = 'string' or (exslt:object-type($image) = 'node-set' and count($image/*) = 0)">
				<xsl:value-of select="$image" />
			</xsl:when>
			<xsl:when test="exslt:object-type($image) = 'node-set' and $use-format = false()">
				<xsl:text>/workspace</xsl:text>
				<xsl:value-of select="$image/@path" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$image/filename" />
			</xsl:when>
			<xsl:when test="exslt:object-type($image) = 'node-set'">
				<xsl:variable name="width" select="round($image/meta/@width div $factor)" />
				<xsl:variable name="height">
					<xsl:choose>
						<xsl:when test="number($parsed-ratio) = $parsed-ratio">
							<xsl:value-of select="round(($image/meta/@width * number($parsed-ratio)) div $factor)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round($image/meta/@height div $factor)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:text>/image/</xsl:text>
				<xsl:choose>
					<xsl:when test="number($parsed-ratio) = $parsed-ratio">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$width" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$height" />
				<xsl:if test="number($parsed-ratio) = $parsed-ratio">/5</xsl:if>
				<xsl:value-of select="$image/@path" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$image/filename" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$image" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- default-image-alt-selector -->
	<xsl:template name="default-image-alt-selector">
		<xsl:call-template name="default-value">
			<xsl:with-param name="a" select="image-alt" />
			<xsl:with-param name="b" select="alt" />
			<xsl:with-param name="c" select="titre" />
			<xsl:with-param name="d" select="title" />
			<xsl:with-param name="e" select="nom" />
			<xsl:with-param name="f" select="name" />
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
