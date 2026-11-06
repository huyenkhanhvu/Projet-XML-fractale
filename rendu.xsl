<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Paramètre qui permet de choisir le système fractal -->
    <xsl:param name="sys_id" select="'sys_sierpinski'"/>

    <!-- Template principal -->
    <xsl:template match="/">

        <!-- Contexte global -->
        <xsl:variable name="root" select="."/>
        <xsl:variable name="sys" select="/fractale/systems/system[@id=$sys_id]"/>
        
        <!-- Détection type fractale -->
        <xsl:variable name="is_compose" select="contains($sys_id, 'compose')"/>
        <xsl:variable name="is_spirale" select="contains($sys_id, 'spirale') and not($is_compose)"/>
        <xsl:variable name="is_sierpinski" select="not($is_compose or $is_spirale)"/>

        <!-- SVG racine -->
        <svg viewBox="-1.2 -1.2 2.4 2.4" width="800" height="800" xmlns="http://www.w3.org/2000/svg">
            
            <!-- Fond blanc -->
            <rect x="-1.2" y="-1.2" width="2.4" height="2.4" fill="white"/>
        
            <!-- Définition des formes et des étapes -->
            <defs>

                <!-- Conversion des formes XML en symboles SVG -->
                <xsl:for-each select="/fractale/formes/forme">

                    <g id="{@id}">

                        <path d="{path/@d}" vector-effect="non-scaling-stroke"/>

                    </g>

                </xsl:for-each>

                <!-- Récursive des étapes de construction -->
                <xsl:call-template name="generate-steps">

                    <xsl:with-param name="root" select="$root"/>
                    <xsl:with-param name="baseRef" select="$sys/base/@ref"/>
                    <xsl:with-param name="steps" select="$sys/step"/>
                    <xsl:with-param name="stepIdx" select="1"/>
                    <xsl:with-param name="is_compose" select="$is_compose"/>
                    <xsl:with-param name="is_spirale" select="$is_spirale"/>
                    <xsl:with-param name="is_sierpinski" select="$is_sierpinski"/>

                </xsl:call-template>
                
            </defs>

            <!-- Dernière étape de la fractale -->
            <xsl:variable name="totalSteps" select="count($sys/step)"/>
            <xsl:variable name="finalIter" select="$sys/step[last()]/@iter"/>
            
            <!-- Affichage final selon le type de fractale -->
            <xsl:choose>

                <xsl:when test="$is_sierpinski">

                    <!-- Fractale remplie -->
                    <use xlink:href="#step-{$totalSteps}-{$finalIter}" fill="blue" stroke="none"/> 

                </xsl:when>

                <xsl:otherwise>

                    <!-- Fractales en contour -->
                    <use xlink:href="#step-{$totalSteps}-{$finalIter}" fill="none" stroke="black" stroke-width="1"/> 

                </xsl:otherwise>

            </xsl:choose>

        </svg>

    </xsl:template>



    <!-- Template récursif de génération des étapes -->
    <xsl:template name="generate-steps">

        <xsl:param name="root"/>
        <xsl:param name="baseRef"/>
        <xsl:param name="steps"/>
        <xsl:param name="stepIdx"/>
        <xsl:param name="is_compose"/>
        <xsl:param name="is_spirale"/>
        <xsl:param name="is_sierpinski"/>

        <!-- Étape actuelle -->
        <xsl:variable name="currentStep" select="$steps[$stepIdx]"/>
        <xsl:variable name="ensembleId" select="$currentStep/@ref"/>
        <xsl:variable name="maxIter" select="xs:integer($currentStep/@iter)"/>

        <!-- Boucle sur itérations -->
        <xsl:for-each select="0 to $maxIter">
            
            <xsl:variable name="i" select="."/>
           
            <!-- Groupe représentant une étape -->
            <g id="step-{$stepIdx}-{$i}">
                
                <!-- Itération 0 -->
                <xsl:choose>

                    <xsl:when test="$i = 0">

                        <xsl:choose>
                            
                            <!-- Uniquement la base d'abord -->
                            <xsl:when test="$stepIdx = 1">

                                <use xlink:href="#{$baseRef}"/>

                            </xsl:when>
                            
                            <!-- Base + Étape précédente a l'étape suivant-->
                            <xsl:otherwise>

                                <xsl:variable name="prevIter" select="$steps[$stepIdx - 1]/@iter"/>
                                
                                <use xlink:href="#{$baseRef}" fill="white" stroke="black" stroke-width="0.025"/>
                                
                                <use xlink:href="#step-{$stepIdx - 1}-{$prevIter}"/>

                            </xsl:otherwise>

                        </xsl:choose>

                    </xsl:when>

                    <!-- Récursion -->
                    <xsl:otherwise>

                        <!-- Application des transformations de l'ensemble -->
                        <xsl:for-each select="$root/fractale/transformations/ensemble[@id=$ensembleId]/transformation">

                            <g>

                                <!-- Construction de la matrice de transformation -->
                                <xsl:attribute name="transform">
                                    
                                    <!-- Translation -->
                                    <xsl:for-each select="translate">

                                        <xsl:text>translate(</xsl:text>
                                        <xsl:value-of select="@tx"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="@ty"/>
                                        <xsl:text>) </xsl:text>

                                    </xsl:for-each>

                                    <!-- Rotation -->
                                    <xsl:for-each select="rotate">

                                        <xsl:text>rotate(</xsl:text>
                                        <xsl:value-of select="@angle"/>
                                        <xsl:text>) </xsl:text>

                                    </xsl:for-each>

                                    <!-- Scale -->
                                    <xsl:for-each select="scale">

                                        <xsl:text>scale(</xsl:text>
                                        <xsl:value-of select="@sx"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="@sy"/>
                                        <xsl:text>) </xsl:text>

                                    </xsl:for-each>

                                </xsl:attribute>

                                <!-- Application récursive de l'étape précédente -->
                                <use xlink:href="#step-{$stepIdx}-{$i - 1}"/>

                            </g>

                        </xsl:for-each>

                        <!-- Rendu selon le type de fractale -->
                        <xsl:choose>

                            <xsl:when test="$is_compose">

                                <use xlink:href="#{$baseRef}" fill="none" stroke="blue" stroke-width="1"/>

                            </xsl:when>

                            <xsl:when test="$is_spirale">

                                <use xlink:href="#{$baseRef}" fill="none" stroke="black" stroke-width="0.015"/>

                            </xsl:when>

                        </xsl:choose>

                    </xsl:otherwise>

                </xsl:choose>

            </g>

        </xsl:for-each>

        <!--  Récursion vers l'étape suivante -->
        <xsl:if test="$stepIdx &lt; count($steps)">

            <xsl:call-template name="generate-steps">
                <xsl:with-param name="root" select="$root"/>
                <xsl:with-param name="baseRef" select="$baseRef"/>
                <xsl:with-param name="steps" select="$steps"/>
                <xsl:with-param name="stepIdx" select="$stepIdx + 1"/>
                <xsl:with-param name="is_compose" select="$is_compose"/>
                <xsl:with-param name="is_spirale" select="$is_spirale"/>
                <xsl:with-param name="is_sierpinski" select="$is_sierpinski"/>

            </xsl:call-template>

        </xsl:if>

    </xsl:template>

</xsl:transform>